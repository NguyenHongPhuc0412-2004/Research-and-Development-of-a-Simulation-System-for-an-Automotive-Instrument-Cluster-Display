/*
 * buzzer.c
 *
 *  KY-012 Active Buzzer Driver
 *
 *  GPIO PB0 được cấu hình bởi CubeMX (MX_GPIO_Init) với Output Level = Low,
 *  tránh buzzer kêu do chân floating trước khi code chạy.
 *  Driver này KHÔNG cấu hình lại GPIO – chỉ điều khiển ON/OFF.
 */

#include "buzzer.h"

/* ── Internal state ───────────────────────────────────────────── */
static uint8_t s_tick = 0;

/* ── Private helper ───────────────────────────────────────────── */
static inline void _buzzer_set(GPIO_PinState state)
{
    HAL_GPIO_WritePin(BUZZER_PORT, BUZZER_PIN, state);
}

/* ── Public API ───────────────────────────────────────────────── */

void Buzzer_Init(void)
{
    /* GPIO đã được CubeMX init với Output Level = Low.
     * Chỉ cần đảm bảo tắt và reset tick. */
    _buzzer_set(GPIO_PIN_RESET);
    s_tick = 0;
}

void Buzzer_Update(uint16_t distance_cm)
{
    if (distance_cm > BUZZER_WARN_CM)
    {
        /* Vùng an toàn: tắt hoàn toàn */
        _buzzer_set(GPIO_PIN_RESET);
        s_tick = 0;
    }
    else if (distance_cm > BUZZER_ALERT_CM)
    {
        /* Vùng cảnh báo (30–60 cm): bíp chậm 1 Hz */
        s_tick = (s_tick + 1) % BUZZER_SLOW_PERIOD_TICKS;
        _buzzer_set((s_tick < BUZZER_SLOW_ON_TICKS) ? GPIO_PIN_SET : GPIO_PIN_RESET);
    }
    else
    {
        /* Vùng nguy hiểm (≤ 30 cm): bíp nhanh 5 Hz */
        s_tick = (s_tick + 1) % BUZZER_FAST_PERIOD_TICKS;
        _buzzer_set((s_tick < BUZZER_FAST_ON_TICKS) ? GPIO_PIN_SET : GPIO_PIN_RESET);
    }
}
