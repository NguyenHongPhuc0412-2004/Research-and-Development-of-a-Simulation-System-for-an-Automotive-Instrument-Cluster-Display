#ifndef ADASPROCESSHANDLER_H
#define ADASPROCESSHANDLER_H

#include <QObject>
#include <QProcess>
#include <QTimer>
#include <QString>
#include <QStringList>

/**
 * @brief AdasProcessHandler
 *
 * Quản lý vòng đời của process Python ADAS và expose dữ liệu lên QML.
 *
 * Giao tiếp với Python qua file trong /tmp/:
 *   /tmp/adas_ready       — flag: Python đã load model xong
 *   /tmp/adas_live.jpg    — frame camera mới nhất (ghi liên tục)
 *   /tmp/adas_stats.json  — { video_fps, ai_fps, obj_count, objects, ts }
 *
 * Đăng ký vào QML (main.cpp):
 *   engine.rootContext()->setContextProperty("adasHandler", &adasHandler);
 *
 * Dùng trong QML:
 *   adasHandler.adasReady        → bool
 *   adasHandler.videoFps         → real
 *   adasHandler.aiFps            → real
 *   adasHandler.objectCount      → int
 *   adasHandler.detectedObjects  → list<string>
 *   adasHandler.framePath        → string  ("file:///tmp/adas_live.jpg?t=N")
 *   adasHandler.startAdas()      → Q_INVOKABLE
 *   adasHandler.stopAdas()       → Q_INVOKABLE
 */
class AdasProcessHandler : public QObject
{
    Q_OBJECT

    Q_PROPERTY(bool        adasReady        READ adasReady        NOTIFY adasReadyChanged)
    Q_PROPERTY(double      videoFps         READ videoFps         NOTIFY statsChanged)
    Q_PROPERTY(double      aiFps            READ aiFps            NOTIFY statsChanged)
    Q_PROPERTY(int         objectCount      READ objectCount      NOTIFY statsChanged)
    Q_PROPERTY(QStringList detectedObjects  READ detectedObjects  NOTIFY statsChanged)
    Q_PROPERTY(QString     framePath        READ framePath        NOTIFY framePathChanged)

public:
    explicit AdasProcessHandler(QObject *parent = nullptr);
    ~AdasProcessHandler() override;

    // ── Getters ──────────────────────────────────────────────────────────────
    bool        adasReady()       const { return m_adasReady; }
    double      videoFps()        const { return m_videoFps; }
    double      aiFps()           const { return m_aiFps; }
    int         objectCount()     const { return m_objectCount; }
    QStringList detectedObjects() const { return m_detectedObjects; }
    QString     framePath()       const { return m_framePath; }

    // ── Invokable từ QML ─────────────────────────────────────────────────────
    Q_INVOKABLE void startAdas(int mode);
    Q_INVOKABLE void stopAdas();

signals:
    void adasReadyChanged();
    void statsChanged();
    void framePathChanged();

private slots:
    void onUpdateTick();
    void onProcessError(QProcess::ProcessError error);
    void onProcessFinished(int exitCode, QProcess::ExitStatus exitStatus);

private:
    void setAdasReady(bool ready);
    void readStats();
    void refreshFramePath();

    QProcess    *m_process     = nullptr;
    QTimer      *m_updateTimer = nullptr;

    bool        m_adasReady       = false;
    double      m_videoFps        = 0.0;
    double      m_aiFps           = 0.0;
    int         m_objectCount     = 0;
    QStringList m_detectedObjects;
    QString     m_framePath;
    int         m_frameCounter    = 0;   // suffix cho framePath để bust cache QML

    // Paths — phải khớp với adas_realtime.py
    static const QString FRAME_PATH;
    static const QString STATS_PATH;
    static const QString READY_FLAG;
    static const QString PYTHON_SCRIPT;  // đường dẫn script Python trên target
};

#endif // ADASPROCESSHANDLER_H
