#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include "delrectangle.h"
#include "deltabviewtype.h"

int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

    qmlRegisterType<DelPen>("DelegateUI.Controls", 1, 0, "DelPen");
    qmlRegisterType<DelRectangle>("DelegateUI.Controls", 1, 0, "DelRectangle");

    qmlRegisterUncreatableMetaObject(DelButtonType::staticMetaObject, "DelegateUI.Controls", 1, 0
                                     , "DelButtonType", "Access to enums & flags only");

    qmlRegisterUncreatableMetaObject(DelTabViewType::staticMetaObject, "DelegateUI.Controls", 1, 0
                                     , "DelTabViewType", "Access to enums & flags only");

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
        &app, [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
