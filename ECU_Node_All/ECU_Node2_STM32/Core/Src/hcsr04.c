/*
 * hcsr04.c
 *
 *  HC-SR04 driver – TIM2 Channel-2 Input Capture
 *
 *  Flow per measurement:
 *    1. HCSR04_TriggerMeasure() pulls TRIG HIGH for 10 µs then LOW.
 *    2. HC-SR04 raises ECHO HIGH → TIM2_CH2 rising-edge ISR fires.
 *       → Save rise_cnt, switch capture to falling edge.
 *    3. HC-SR04 pulls ECHO LOW → falling-edge ISR fires.
 *       → duration = fall_cnt – rise_cnt (µs, handles 16-bit wrap).
 *       → distance_cm = duration / 58, clamped to 0-400 cm.
 */

#include "hcsr04.h"

/* ── Internal state machine ───────────────────────────────────── */
typedef enum {
    STATE_IDLE      = 0,
    STATE_WAIT_RISE,   /* waiting for ECHO to go HIGH */
    STATE_WAIT_FALL,   /* waiting for ECHO to go LOW  */
    STATE_DONE         /* distance computed            */
} HCSR04_State;

static volatile HCSR04_State s_state      = STATE_IDLE;
static volatile uint32_t     s_rise_cnt   = 0;
static volatile uint16_t     s_distance   = HCSR04_MAX_DISTANCE_CM;
static volatile bool         s_ready      = false;

/* ── Private: 10-µs busy-wait using TIM2 counter (1 MHz) ─────── */
static void _delay_us(uint16_t us)
{
    uint32_t start = __HAL_TIM_GET_COUNTER(&htim2);
    /* 16-bit subtraction handles counter wrap correctly */
    while ((uint16_t)(__HAL_TIM_GET_COUNTER(&htim2) - start) < us);
}

/* ── Public API ───────────────────────────────────────────────── */

void HCSR04_Init(void)
{
    /* TIM2 base + IC already configured by MX_TIM2_Init().
     * Just enable the IC interrupt and ensure TRIG starts LOW. */
    HAL_GPIO_WritePin(HCSR04_TRIG_PORT, HCSR04_TRIG_PIN, GPIO_PIN_RESET);

    /* Capture rising edge first */
    __HAL_TIM_SET_CAPTUREPOLARITY(&htim2, HCSR04_TIM_CHANNEL,
                                   TIM_INPUTCHANNELPOLARITY_RISING);
    HAL_TIM_IC_Start_IT(&htim2, HCSR04_TIM_CHANNEL);

    s_state    = STATE_IDLE;
    s_ready    = false;
    s_distance = HCSR04_MAX_DISTANCE_CM;
}

void HCSR04_TriggerMeasure(void)
{
    /* Reject if previous measurement still running */
    if (s_state == STATE_WAIT_RISE || s_state == STATE_WAIT_FALL)
        return;

    /* Enter critical section to reset state atomically */
    __disable_irq();
    s_ready = false;
    s_state = STATE_WAIT_RISE;
    __enable_irq();

    /* Arm for rising edge */
    __HAL_TIM_SET_CAPTUREPOLARITY(&htim2, HCSR04_TIM_CHANNEL,
                                   TIM_INPUTCHANNELPOLARITY_RISING);

    /* Send 10 µs TRIG pulse */
    HAL_GPIO_WritePin(HCSR04_TRIG_PORT, HCSR04_TRIG_PIN, GPIO_PIN_SET);
    _delay_us(10);
    HAL_GPIO_WritePin(HCSR04_TRIG_PORT, HCSR04_TRIG_PIN, GPIO_PIN_RESET);
}

void HCSR04_IC_CaptureCallback(TIM_HandleTypeDef *htim)
{
    if (htim->Instance != TIM2) return;
    if (htim->Channel  != HAL_TIM_ACTIVE_CHANNEL_2) return;

    if (s_state == STATE_WAIT_RISE) {
        /* Rising edge: record start timestamp */
        s_rise_cnt = HAL_TIM_ReadCapturedValue(htim, HCSR04_TIM_CHANNEL);
        s_state    = STATE_WAIT_FALL;

        /* Switch to capture falling edge next */
        __HAL_TIM_SET_CAPTUREPOLARITY(htim, HCSR04_TIM_CHANNEL,
                                       TIM_INPUTCHANNELPOLARITY_FALLING);
    }
    else if (s_state == STATE_WAIT_FALL) {
        /* Falling edge: compute pulse duration */
        uint32_t fall_cnt = HAL_TIM_ReadCapturedValue(htim, HCSR04_TIM_CHANNEL);

        /* 16-bit wrap-safe subtraction (TIM2 period = 0xFFFF, 1 µs/tick) */
        uint32_t duration_us;
        if (fall_cnt >= s_rise_cnt)
            duration_us = fall_cnt - s_rise_cnt;
        else
            duration_us = (0xFFFFUL - s_rise_cnt) + fall_cnt + 1UL;

        /* distance_cm = duration_µs / 58   (sound: 340 m/s, round-trip) */
        uint16_t dist = (uint16_t)(duration_us / 58U);
        if (dist > HCSR04_MAX_DISTANCE_CM)
            dist = HCSR04_MAX_DISTANCE_CM;

        s_distance = dist;
        s_ready    = true;
        s_state    = STATE_DONE;

        /* Re-arm for next rising edge */
        __HAL_TIM_SET_CAPTUREPOLARITY(htim, HCSR04_TIM_CHANNEL,
                                       TIM_INPUTCHANNELPOLARITY_RISING);
    }
}

uint16_t HCSR04_GetDistance(void) { return s_distance; }
bool     HCSR04_IsReady(void)     { return s_ready;    }
void     HCSR04_ClearReady(void)  { s_ready = false;   }
