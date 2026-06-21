#ifndef CANHANDLER_H
#define CANHANDLER_H

#include <QObject>
#include <QThread>
#include <QString>
#include <QMutex>
#include <QQueue>
#include <linux/can.h>
#include <cstdint>
#include <QFile>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonValue>
#include <QTimer>
#include <QMap>
#include <QString>

// CAN IDs - Có thể thay đổi sau khi có thông tin từ STM32
#define DIGITAL_OUTPUT_CMD_ID(n)          (0x94FF0000UL + ((n) * 0x20UL))
#define DIGITAL_OUTPUT_RES_ID(n)          (0x94FF0800UL + ((n) * 0x20UL))
#define DIGITAL_INPUT_RES_ID(n)           (0x94FF0A00UL + ((n) * 0x20UL))
#define ANALOG_INPUT_RES_ID(n)            (0x94FF0D00UL + ((n) * 0x20UL))

#define RTC_TIME_RES_ID                   0x94FF0F00UL


#define NUMBER_OF_DIG_OUT_CMD_FRAME       4U
#define NUMBER_OF_DIG_OUT_RES_FRAME       8U
#define NUMBER_OF_DIG_IN_RES_FRAME        4U
#define NUMBER_OF_ANALOG_IN_RES_FRAME     8U

// CAN Frame Signal Per Frame
#define DIGITAL_OUT_CMD_SIGNAL_PER_FRAME  8U
#define DIGITAL_OUT_RESP_SIGNAL_PER_FRAME 4U
#define DIGITAL_IN_RESP_SIGNAL_PER_FRAME  8U
#define ANALOG_IN_RESP_SIGNAL_PER_FRAME   4U

#define BYTES_PER_CAN_FRAME               8U

#define ANALOG_VALUE_BITS                 14U
#define ANALOG_EL_DIAGNOSIS_BITS          2U

#define HCSR04_DANGER_CM    30U   /* danger zone */
#define HCSR04_WARNING_CM  100U   /* caution zone */
#define HCSR04_MAX_CM      400U   /* sensor max range */

/*
 * @brief Analog Input Response (ECU -> VCU)
 */
typedef struct
{
    uint16_t analogValue   : ANALOG_VALUE_BITS;
    uint8_t elDiagnosis    : ANALOG_EL_DIAGNOSIS_BITS;
} AnalogInput_Resp;

typedef union {
    uint64_t sdu;
    AnalogInput_Resp signal[ANALOG_IN_RESP_SIGNAL_PER_FRAME];
} AnalogInput_Resp_Frame;

struct IOConfig {
    QMap<QString, uint8_t> digInputs;
    QMap<QString, int> analogInputs;
    QMap<QString, uint8_t> digOutputs;
};

struct digInSignal {
    bool ignition = false;
    bool turn_left_switch = false;
    bool turn_right_switch = false;
    bool hazard_switch = false;
    bool high_beam_switch = false;
    bool low_beam_switch = false;
    bool parking_lights_switch = false;
    bool crash_sensor = false;
};

struct digOutSignal {
    bool left_front_light = false;
    bool left_rear_light = false;
    bool right_front_light = false;
    bool right_rear_light = false;
    uint8_t left_front_light_pos = 0;
    uint8_t left_rear_light_pos = 0;
    uint8_t right_front_light_pos = 0;
    uint8_t right_rear_light_pos = 0;
    uint8_t left_door_servo_pos = 0;    
    uint8_t right_door_servo_pos = 0;  
};

struct analogInSignal {
    int speed = 0;
    int battery = 100;      // Battery percentage (0-100)
    int temperature = 25;   // Temperature in Celsius
    int humidity = 50;      // Humidity percentage (0-100) - THÊM MỚI
    int encoder = 0;
    int ultrasonic = HCSR04_MAX_CM;
};

/*
 * @brief Load the IO configuration from a JSON file.
 * @param path: The path to the JSON file containing the IO configuration.
 * @return IOConfig object containing the loaded configuration.
 */
IOConfig loadIOConfig(const QString& path);

class CanTxThread : public QThread {
    Q_OBJECT
public:
    CanTxThread(QObject *parent = nullptr);
    ~CanTxThread();

    void enqueueMessage(const struct can_frame &frame);
    void stop();
    void sendDigitalOutputCommand(uint8_t outputIndex, uint8_t switchCmd, uint8_t dutyCycle);


protected:
    void run() override;

private:
    int m_socket;
    bool m_running;
    QMutex m_mutex;
    QQueue<struct can_frame> m_queue;

signals:
    void leftLightChanged(bool leftLight);
    void rightLightChanged(bool rightLight);
    void hazardLightsChanged(bool hazardLights);
};

class CanRxThread : public QThread {
    Q_OBJECT
public:
    CanRxThread(QObject *parent = nullptr);
    ~CanRxThread();

    void stop();

protected:
    void run() override;

signals:
    void highBeamChanged(bool highBeam);
    void lowBeamChanged(bool lowBeam);
    void parkingLightsChanged(bool parkingLights);
    void speedChanged(int speed);
    void batteryChanged(int battery);
    void temperatureChanged(int temperature);
    void humidityChanged(int humidity);
    void encoderSpeedChanged(int encoderSpeed);
    void buttonStateChanged(int buttonIndex, int state);
    void specificButtonPressed(int buttonId);
    void carLightsToggled(bool state);
    void sendDigitalOutputRequest(int outputIndex, int switchCmd, int dutyCycle);
    void bmsDataReceived(float soc, float voltage, float current);
    void rtcTimeChanged(int year, int month, int date,int hours, int minutes, int seconds,int dow, bool valid);
    void ultrasonicDistanceChanged(int distanceCm);
    void crashDetected();

private:
    int m_socket;
    bool m_running;
};

class DataProcessing : public QObject {
    Q_OBJECT
public:
    DataProcessing();
    QTimer *timer;
public slots:
    void DataProcessingTask();
};

class CanHandler : public QObject {
    Q_OBJECT
    Q_PROPERTY(float bmsSoc READ getBmsSoc NOTIFY bmsSocChanged)
    Q_PROPERTY(float bmsVoltage READ getBmsVoltage NOTIFY bmsVoltageChanged)
    Q_PROPERTY(float bmsCurrent READ getBmsCurrent NOTIFY bmsCurrentChanged)
    Q_PROPERTY(int leftDoorIndex READ leftDoorIndex CONSTANT)
    Q_PROPERTY(int rightDoorIndex READ rightDoorIndex CONSTANT)
public:
    explicit CanHandler(QObject *parent = nullptr);
    ~CanHandler();
     Q_INVOKABLE void sendOutputCommand(int outputIndex, int switchCmd, int dutyCycle) {
        m_txThread->sendDigitalOutputCommand(outputIndex, switchCmd, dutyCycle);
    }
    float getBmsSoc() const { return m_bmsSoc; }
    float getBmsVoltage() const { return m_bmsVoltage; }
    float getBmsCurrent() const { return m_bmsCurrent; }
    int leftDoorIndex() const;                                     
    int rightDoorIndex() const;  

signals:
    void leftLightChanged(bool leftLight);
    void rightLightChanged(bool rightLight);
    void hazardLightsChanged(bool hazardLights);
    void highBeamChanged(bool highBeam);
    void lowBeamChanged(bool lowBeam);
    void parkingLightsChanged(bool parkingLights);
    void speedChanged(int speed);
    void batteryChanged(int battery);
    void temperatureChanged(int temperature);
    void humidityChanged(int humidity);
    void encoderSpeedChanged(int encoderSpeed);
    void buttonStateChanged(int buttonIndex, int state);
    void specificButtonPressed(int buttonId);
    void carLightsToggled(bool state);
    void bmsSocChanged();
    void bmsVoltageChanged();
    void bmsCurrentChanged();
    void rtcTimeChanged(int year, int month, int date, int hours, int minutes, int seconds, int dow, bool valid);
    void ultrasonicDistanceChanged(int distanceCm);
    void crashDetected();

private slots:
    // Slot để nhận dữ liệu từ thread
    void updateBmsData(float soc, float voltage, float current);

private:
    CanTxThread *m_txThread;
    CanRxThread *m_rxThread;
    DataProcessing *m_dataProcessing;
    
    float m_bmsSoc = 100.0f;
    float m_bmsVoltage = 0.0f;
    float m_bmsCurrent = 0.0f;
};

#endif // CANHANDLER_H
