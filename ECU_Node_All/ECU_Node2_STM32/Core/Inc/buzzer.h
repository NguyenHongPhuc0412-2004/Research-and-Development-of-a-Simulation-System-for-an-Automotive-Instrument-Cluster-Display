#ifndef INC_BUZZER_H_
#define INC_BUZZER_H_

#include "stm32f1xx_hal.h"
#include <stdint.h>

/* ── Hardware ─────────────────────────────────────────────────── */
#define BUZZER_PIN               GPIO_PIN_10   /* PB0 */
#define BUZZER_PORT              GPIOB

/* ── Ngưỡng khoảng cách (cm) ─────────────────────────────────── */
#define BUZZER_WARN_CM           60U   /* > 60 cm → im lặng         */
#define BUZZER_ALERT_CM          30U   /* ≤ 30 cm → bíp nhanh       */
                                       /* 30–60 cm → bíp chậm       */

/*
 *  Đơn vị 1 tick = 1 lần gọi Buzzer_Update() = 100 ms
 *
 *  Bíp chậm  : ON 3 tick (300 ms), OFF 7 tick (700 ms) → chu kỳ 1 s
 *  Bíp nhanh : ON 1 tick (100 ms), OFF 1 tick (100 ms) → chu kỳ 200 ms
 */
#define BUZZER_SLOW_ON_TICKS     3U
#define BUZZER_SLOW_PERIOD_TICKS 10U   /* 3 ON + 7 OFF */
#define BUZZER_FAST_ON_TICKS     1U
#define BUZZER_FAST_PERIOD_TICKS 2U    /* 1 ON + 1 OFF */

/* ── Public API ───────────────────────────────────────────────── */

/**
 * @brief  Khởi tạo GPIO PB0, tắt buzzer.
 *         Gọi 1 lần trong main() sau MX_GPIO_Init().
 */
void Buzzer_Init(void);

/**
 * @brief  Cập nhật trạng thái buzzer theo khoảng cách.
 *         Gọi định kỳ mỗi 100 ms trong CANTxHandler, không cần task riêng.
 * @param  distance_cm  Khoảng cách từ HC-SR04 (cm).
 */
void Buzzer_Update(uint16_t distance_cm);

#endif /* INC_BUZZER_H_ */
