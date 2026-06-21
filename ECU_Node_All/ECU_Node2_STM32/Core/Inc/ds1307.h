/*
 * ds1307.h
 *
 *  Created on: May 30, 2026
 *      Author: Phuc
 */

#ifndef INC_DS1307_H_
#define INC_DS1307_H_

#include "stm32f1xx_hal.h"
#include <stdint.h>
#include <stdbool.h>

/* ── I2C address & registers ──────────────────────────────────── */
#define DS1307_I2C_ADDR_7BIT   0x68U          /* 7-bit slave address  */
#define DS1307_I2C_ADDR        (DS1307_I2C_ADDR_7BIT << 1)

#define DS1307_REG_SECONDS     0x00U
#define DS1307_REG_MINUTES     0x01U
#define DS1307_REG_HOURS       0x02U
#define DS1307_REG_DAY         0x03U          /* day-of-week 1–7      */
#define DS1307_REG_DATE        0x04U
#define DS1307_REG_MONTH       0x05U
#define DS1307_REG_YEAR        0x06U
#define DS1307_REG_CONTROL     0x07U

#define DS1307_CH_BIT          0x80U          /* bit7 reg seconds: Clock Halt */
#define DS1307_HOUR_12_BIT     0x40U          /* bit6 reg hours: 12h mode     */
#define DS1307_HOUR_PM_BIT     0x20U          /* bit5 reg hours: PM (12h mode)*/

#define DS1307_I2C_TIMEOUT_MS  100U

/* I2C handle*/
extern I2C_HandleTypeDef hi2c1;

/* ── Time structure ───────────────── */
typedef struct {
    uint8_t seconds;   /* 0–59  */
    uint8_t minutes;   /* 0–59  */
    uint8_t hours;     /* 0–23 (24h)  */
    uint8_t dow;       /* 1–7 (day of week) */
    uint8_t date;      /* 1–31  */
    uint8_t month;     /* 1–12  */
    uint8_t year;      /* 0–99 (offset 2000) */
} DS1307_Time;

/**
 * @brief  Init DS1307: check connector I2C, clear bit CH (Clock Halt)
 *         to watch run, cast mode 24h.
 *         call one after MX_I2C1_Init().
 * @retval true if DS1307 respone on bus I2C, false if error.
 */
bool DS1307_Init(void);

/**
 * @brief  Read and write all time present to DS1307..
 * @retval true if read successful, false if error I2C.
 */
bool DS1307_GetTime(DS1307_Time *t);

bool DS1307_SetTime(const DS1307_Time *t);



#endif /* INC_DS1307_H_ */
