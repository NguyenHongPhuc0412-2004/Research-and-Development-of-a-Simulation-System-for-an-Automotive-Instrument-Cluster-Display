#include "adasprocesshandler.h"

#include <QDebug>
#include <QFile>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>

// ── Static constants: phải khớp với adas_realtime.py ─────────────────────────
const QString AdasProcessHandler::FRAME_PATH    = QStringLiteral("/tmp/adas_live.jpg");
const QString AdasProcessHandler::STATS_PATH    = QStringLiteral("/tmp/adas_stats.json");
const QString AdasProcessHandler::READY_FLAG    = QStringLiteral("/tmp/adas_ready");

// Đường dẫn Python script trên Yocto/RPi.
// Thay đổi nếu deploy ở chỗ khác (vd: "/usr/bin/adas_realtime.py")
const QString AdasProcessHandler::PYTHON_SCRIPT = QStringLiteral("/opt/adas/adas_realtime.py");


// ─────────────────────────────────────────────────────────────────────────────

AdasProcessHandler::AdasProcessHandler(QObject *parent)
    : QObject(parent)
{
    // Timer cập nhật mỗi 100ms: đọc stats JSON + check ready flag + refresh framePath
    m_updateTimer = new QTimer(this);
    m_updateTimer->setInterval(100);
    connect(m_updateTimer, &QTimer::timeout, this, &AdasProcessHandler::onUpdateTick);
}

AdasProcessHandler::~AdasProcessHandler()
{
    stopAdas();
}


// ─── Public slots ─────────────────────────────────────────────────────────────

void AdasProcessHandler::startAdas(int mode)
{
    if (m_process && m_process->state() != QProcess::NotRunning) {
        qDebug() << "[ADAS] Already running";
        return;
    }

    // Dọn flag cũ trước khi khởi động
    QFile::remove(READY_FLAG);
    QFile::remove(FRAME_PATH);
    QFile::remove(STATS_PATH);

    m_process = new QProcess(this);
    connect(m_process, &QProcess::errorOccurred, this, &AdasProcessHandler::onProcessError);
    connect(m_process, QOverload<int, QProcess::ExitStatus>::of(&QProcess::finished), this, &AdasProcessHandler::onProcessFinished);

    // Forward log từ Python ra Qt debug console
    connect(m_process, &QProcess::readyReadStandardOutput, this, [this]() {
        qDebug() << "[ADAS py]" << m_process->readAllStandardOutput().trimmed();
    });
    connect(m_process, &QProcess::readyReadStandardError, this, [this]() {
        qWarning() << "[ADAS py ERR]" << m_process->readAllStandardError().trimmed();
    });

    // Lập danh sách tham số dòng lệnh truyền cho Python
    QStringList args;
    args << PYTHON_SCRIPT;
    args << QString::number(mode); // Truyền "0" hoặc "1" làm đối số

    m_process->setWorkingDirectory(QStringLiteral("/opt/adas"));
    m_process->start(QStringLiteral("python3"), args); // Chạy python3 /opt/adas/adas_realtime.py <mode>

    if (!m_process->waitForStarted(5000)) {
        qWarning() << "[ADAS] Failed to start Python process:" << m_process->errorString();
        m_process->deleteLater();
        m_process = nullptr;
        return;
    }

    qDebug() << "[ADAS] Python process started with Mode:" << mode << " PID:" << m_process->processId();
    m_updateTimer->start();
}

void AdasProcessHandler::stopAdas()
{
    m_updateTimer->stop();

    if (m_process && m_process->state() != QProcess::NotRunning) {
        qDebug() << "[ADAS] Stopping Python process...";
        m_process->terminate();

        // Cho 3 giây để process tự dọn (picam2.stop() etc.)
        if (!m_process->waitForFinished(3000)) {
            m_process->kill();
        }
        m_process->deleteLater();
        m_process = nullptr;
    }

    // Reset state
    setAdasReady(false);
    m_videoFps       = 0.0;
    m_aiFps          = 0.0;
    m_objectCount    = 0;
    m_detectedObjects.clear();
    m_framePath      = QString();
    m_frameCounter   = 0;

    emit statsChanged();
    emit framePathChanged();

    // Dọn file tạm
    QFile::remove(READY_FLAG);
}


// ─── Private slots ────────────────────────────────────────────────────────────

void AdasProcessHandler::onUpdateTick()
{
    // 1. Kiểm tra ready flag
    if (!m_adasReady) {
        if (QFile::exists(READY_FLAG)) {
            setAdasReady(true);
            qDebug() << "[ADAS] Module is ONLINE";
        } else {
            return;  // Chưa ready, không cần đọc stats/frame
        }
    }

    // 2. Đọc stats JSON
    readStats();

    // 3. Refresh framePath nếu file tồn tại
    if (QFile::exists(FRAME_PATH)) {
        refreshFramePath();
    }
}

void AdasProcessHandler::onProcessError(QProcess::ProcessError error)
{
    qWarning() << "[ADAS] Process error:" << error;
    setAdasReady(false);
}

void AdasProcessHandler::onProcessFinished(int exitCode, QProcess::ExitStatus exitStatus)
{
    qDebug() << "[ADAS] Process finished. Exit code:" << exitCode
             << "Status:" << exitStatus;
    setAdasReady(false);
    m_updateTimer->stop();
}


// ─── Private helpers ──────────────────────────────────────────────────────────

void AdasProcessHandler::setAdasReady(bool ready)
{
    if (m_adasReady == ready) return;
    m_adasReady = ready;
    emit adasReadyChanged();
}

void AdasProcessHandler::readStats()
{
    QFile file(STATS_PATH);
    if (!file.open(QIODevice::ReadOnly)) return;

    const QByteArray data = file.readAll();
    file.close();

    QJsonParseError parseError;
    const QJsonDocument doc = QJsonDocument::fromJson(data, &parseError);
    if (parseError.error != QJsonParseError::NoError || !doc.isObject()) return;

    const QJsonObject obj = doc.object();

    m_videoFps     = obj.value(QStringLiteral("video_fps")).toDouble(m_videoFps);
    m_aiFps        = obj.value(QStringLiteral("ai_fps")).toDouble(m_aiFps);
    m_objectCount  = obj.value(QStringLiteral("obj_count")).toInt(m_objectCount);

    const QJsonArray arr = obj.value(QStringLiteral("objects")).toArray();
    m_detectedObjects.clear();
    for (const QJsonValue &v : arr) {
        m_detectedObjects << v.toString();
    }

    emit statsChanged();
}

void AdasProcessHandler::refreshFramePath()
{
    // Thêm counter vào URL để QML Image biết reload (bust cache)
    // QML Image với cache:false vẫn cần URL khác nhau để trigger reload
    m_frameCounter = (m_frameCounter + 1) % 999999;
    m_framePath = QStringLiteral("file://") + FRAME_PATH
                + QStringLiteral("?t=") + QString::number(m_frameCounter);
    emit framePathChanged();
}
