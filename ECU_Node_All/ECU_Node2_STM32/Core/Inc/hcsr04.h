/*
 * hcsr04.h
 *
 *  HC-SR04 Ultrasonic Distance Sensor Driver
 *  TRIG → PA3 (GPIO Output)
 *  ECHO → PA1 (TIM2_CH2 Input Capture)
 *
 *  Timer config: TIM2, Prescaler=71 → 1MHz → 1 tick = 1µs
 *  Distance: duration_us / 58 = cm
 *
 *  Created for ECU2 (STM32F103C8T6)
 */

#ifndef HCSR04_H
#define HCSR04_H

#include "stm32f1xx_hal.h"
#include <stdint.h>
#include <stdbool.h>

/* ── Hardware mapping ─────────────────────────────────────────── */
#define HCSR04_TRIG_PORT          GPIOA
#define HCSR04_TRIG_PIN           GPIO_PIN_3   /* PA3 → TRIG */
#define HCSR04_TIM_CHANNEL        TIM_CHANNEL_2 /* PA1 → TIM2_CH2 → ECHO */

/* ── Measurement params ───────────────────────────────────────── */
#define HCSR04_MAX_DISTANCE_CM    400U          /* HC-SR04 max range */
#define HCSR04_MEASURE_INTERVAL_MS 60U          /* trigger period (ms) */
#define HCSR04_TIMEOUT_MS         25U           /* 400cm*58us = 23.2ms, round up */

/* TIM2 handle (defined in main.c, declared extern here) */
extern TIM_HandleTypeDef htim2;

/* ── Public API ───────────────────────────────────────────────── */

/**
 * @brief  Initialise HC-SR04: start TIM2 IC interrupt, clear state.
 *         Call once after MX_TIM2_Init().
 */
void HCSR04_Init(void);

/**
 * @brief  Send 10 µs TRIG pulse to start one measurement cycle.
 *         Safe to call from a FreeRTOS task (≤ 15 µs blocking).
 */
void HCSR04_TriggerMeasure(void);

/**
 * @brief  Must be called from HAL_TIM_IC_CaptureCallback().
 *         Handles rising-edge (start) and falling-edge (stop) captures.
 */
void HCSR04_IC_CaptureCallback(TIM_HandleTypeDef *htim);

/**
 * @brief  Return last computed distance in cm (0 – 400).
 *         Returns HCSR04_MAX_DISTANCE_CM when no valid reading yet.
 */
uint16_t HCSR04_GetDistance(void);

/**
 * @brief  True when a fresh reading has been stored since last trigger.
 */
bool HCSR04_IsReady(void);

/**
 * @brief  Reset ready flag (call after consuming the reading).
 */
void HCSR04_ClearReady(void);

#endif /* HCSR04_H */
