#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlEngine>
#include <QQmlContext>
#include <QDir>
#include "radialbar.h"
#include "canhandler.h"
#include "adasprocesshandler.h"   // ← THÊM MỚI

int main(int argc, char *argv[])
{
    qputenv("QSG_RENDER_LOOP", "basic");
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
    QGuiApplication app(argc, argv);

    // CAN handler (giữ nguyên)
    CanHandler canHandler;

    // ADAS process handler
    AdasProcessHandler adasHandler;

    QQmlApplicationEngine engine;

    // Đăng ký vào QML context
    engine.rootContext()->setContextProperty("canHandler",  &canHandler);
    engine.rootContext()->setContextProperty("adasHandler", &adasHandler);  

    // Custom types (giữ nguyên)
    qmlRegisterType<RadialBar>("CustomControls", 1, 0, "RadialBar");
    qmlRegisterSingletonType(QUrl(QStringLiteral("qrc:/Style.qml")),
                             "Style", 1, 0, "Style");

    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated, &app,
                     [url](QObject *obj, const QUrl &objUrl) {
                         if (!obj && url == objUrl)
                             QCoreApplication::exit(-1);
                     }, Qt::QueuedConnection);

    engine.load(url);
    return app.exec();
}
