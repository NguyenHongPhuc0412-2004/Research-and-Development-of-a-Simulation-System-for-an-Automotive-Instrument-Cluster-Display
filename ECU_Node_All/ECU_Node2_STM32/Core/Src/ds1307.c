/*
 * ds1307.c
 *
 *  Created on: May 30, 2026
 *      Author: Phuc
 */

#include "ds1307.h"

/* ── Private helpers: BCD -> DEC ───────────────────────────────── */
static inline uint8_t _bcd2dec(uint8_t bcd)
{
    return (uint8_t)((bcd >> 4) * 10U + (bcd & 0x0FU));
}

static inline uint8_t _dec2bcd(uint8_t dec)
{
    return (uint8_t)(((dec / 10U) << 4) | (dec % 10U));
}

/* ── Private: read/write register ─────────────────────────────── */
static bool _read_reg(uint8_t reg, uint8_t *val)
{
    return HAL_I2C_Mem_Read(&hi2c1, DS1307_I2C_ADDR, reg,
                            I2C_MEMADD_SIZE_8BIT, val, 1U,
                            DS1307_I2C_TIMEOUT_MS) == HAL_OK;
}

static bool _write_reg(uint8_t reg, uint8_t val)
{
    return HAL_I2C_Mem_Write(&hi2c1, DS1307_I2C_ADDR, reg,
                             I2C_MEMADD_SIZE_8BIT, &val, 1U,
                             DS1307_I2C_TIMEOUT_MS) == HAL_OK;
}

/* ── Public API ───────────────────────────────────────────────── */

bool DS1307_Init(void)
{
    if (HAL_I2C_IsDeviceReady(&hi2c1, DS1307_I2C_ADDR, 3U,
                              DS1307_I2C_TIMEOUT_MS) != HAL_OK)
        return false;

    /* 2. Read seconds register, clear bit CH.*/
    uint8_t sec;
    if (!_read_reg(DS1307_REG_SECONDS, &sec))
        return false;

    if (sec & DS1307_CH_BIT) {
        sec &= (uint8_t)~DS1307_CH_BIT;
        if (!_write_reg(DS1307_REG_SECONDS, sec))
            return false;
    }

    /* 3. Cast register to active mode 24h (clear bit6) if 12h */
    uint8_t hr;
    if (!_read_reg(DS1307_REG_HOURS, &hr))
        return false;

    if (hr & DS1307_HOUR_12_BIT) {
        /* if 12h → exchange to value 24h*/
        uint8_t hour12 = _bcd2dec((uint8_t)(hr & 0x1FU));
        bool    pm     = (hr & DS1307_HOUR_PM_BIT) != 0U;

        if (hour12 == 12U) hour12 = 0U;          /* 12 AM → 0  */
        uint8_t hour24 = pm ? (hour12 + 12U) : hour12;

        if (!_write_reg(DS1307_REG_HOURS, _dec2bcd(hour24)))
            return false;
    }

    (void)_write_reg(DS1307_REG_CONTROL, 0x00U);

    return true;
}

bool DS1307_GetTime(DS1307_Time *t)
{
    uint8_t raw[7];

    /* Đọc liên tiếp 7 thanh ghi 0x00–0x06 trong một lần */
    if (HAL_I2C_Mem_Read(&hi2c1, DS1307_I2C_ADDR, DS1307_REG_SECONDS,
                         I2C_MEMADD_SIZE_8BIT, raw, 7U,
                         DS1307_I2C_TIMEOUT_MS) != HAL_OK)
        return false;

    /* Giây: bỏ bit CH (bit7) trước khi decode */
    t->seconds = _bcd2dec((uint8_t)(raw[0] & 0x7FU));
    t->minutes = _bcd2dec((uint8_t)(raw[1] & 0x7FU));

    /* Giờ: xử lý cả 2 chế độ, luôn trả về 24h */
    if (raw[2] & DS1307_HOUR_12_BIT) {
        uint8_t hour12 = _bcd2dec((uint8_t)(raw[2] & 0x1FU));
        bool    pm     = (raw[2] & DS1307_HOUR_PM_BIT) != 0U;
        if (hour12 == 12U) hour12 = 0U;
        t->hours = pm ? (hour12 + 12U) : hour12;
    } else {
        t->hours = _bcd2dec((uint8_t)(raw[2] & 0x3FU));
    }

    t->dow   = _bcd2dec((uint8_t)(raw[3] & 0x07U));
    t->date  = _bcd2dec((uint8_t)(raw[4] & 0x3FU));
    t->month = _bcd2dec((uint8_t)(raw[5] & 0x1FU));
    t->year  = _bcd2dec(raw[6]);

    return true;
}

bool DS1307_SetTime(const DS1307_Time *t)
{
    uint8_t raw[7];

    /* Encode DEC → BCD. Bit CH = 0 (giây) để đồng hồ chạy.
     * Giờ ghi ở chế độ 24h (bit6 = 0). */
    raw[0] = (uint8_t)(_dec2bcd(t->seconds) & 0x7FU);
    raw[1] = _dec2bcd(t->minutes);
    raw[2] = (uint8_t)(_dec2bcd(t->hours) & 0x3FU);
    raw[3] = _dec2bcd(t->dow);
    raw[4] = _dec2bcd(t->date);
    raw[5] = _dec2bcd(t->month);
    raw[6] = _dec2bcd(t->year);

    return HAL_I2C_Mem_Write(&hi2c1, DS1307_I2C_ADDR, DS1307_REG_SECONDS,
                             I2C_MEMADD_SIZE_8BIT, raw, 7U,
                             DS1307_I2C_TIMEOUT_MS) == HAL_OK;
}

