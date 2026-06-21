/* USER CODE BEGIN Header */
/**
  ******************************************************************************
  * @file           : main.h
  * @brief          : Header for main.c file.
  *                   This file contains the common defines of the application.
  ******************************************************************************
  * @attention
  *
  * <h2><center>&copy; Copyright (c) 2025 STMicroelectronics.
  * All rights reserved.</center></h2>
  *
  * This software component is licensed by ST under BSD 3-Clause license,
  * the "License"; You may not use this file except in compliance with the
  * License. You may obtain a copy of the License at:
  *                        opensource.org/licenses/BSD-3-Clause
  *
  ******************************************************************************
  */
/* USER CODE END Header */

/* Define to prevent recursive inclusion -------------------------------------*/
#ifndef __MAIN_H
#define __MAIN_H

#ifdef __cplusplus
extern "C" {
#endif

/* Includes ------------------------------------------------------------------*/
#include "stm32f1xx_hal.h"

/* Private includes ----------------------------------------------------------*/
/* USER CODE BEGIN Includes */
/* USER CODE END Includes */

/* Exported types ------------------------------------------------------------*/
/* USER CODE BEGIN ET */

/* USER CODE END ET */

/* Exported constants --------------------------------------------------------*/
/* USER CODE BEGIN EC */

/* USER CODE END EC */

/* Exported macro ------------------------------------------------------------*/
/* USER CODE BEGIN EM */

/* USER CODE END EM */

void HAL_TIM_MspPostInit(TIM_HandleTypeDef *htim);

/* Exported functions prototypes ---------------------------------------------*/
void Error_Handler(void);

/* USER CODE BEGIN EFP */

/* USER CODE END EFP */

/* Private defines -----------------------------------------------------------*/
#define HCSR04_TRIG_Pin GPIO_PIN_3
#define HCSR04_TRIG_GPIO_Port GPIOA
#define BUZZER_Pin GPIO_PIN_10
#define BUZZER_GPIO_Port GPIOB
#define OCCUPANT_SENSOR_Pin GPIO_PIN_12
#define OCCUPANT_SENSOR_GPIO_Port GPIOB
#define DIGITAL_OUT_28_Pin GPIO_PIN_8
#define DIGITAL_OUT_28_GPIO_Port GPIOA
#define DIGITAL_OUT_19_Pin GPIO_PIN_9
#define DIGITAL_OUT_19_GPIO_Port GPIOA

/* USER CODE BEGIN Private defines */
#define ZERO                    0U
#define ONE                     1U
#define TWO                     2U
#define THREE                   3U
#define FOUR                    4U
#define FIVE                    5U
#define SIX                     6U
#define SEVEN                   7U
#define EIGHT                   8U
#define NINE                    9U
#define TEN                     10U

#define DHT11_DATA_Pin GPIO_PIN_4
#define DHT11_DATA_GPIO_Port GPIOA
#define TEMP_ALARM_THRESHOLD    50.0f  // 50°C

/* USER CODE END Private defines */

#ifdef __cplusplus
}
#endif

#endif /* __MAIN_H */
