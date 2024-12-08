#include <QGuiApplication>
#include <QQmlApplicationEngine>

namespace DelButtonType {
    Q_NAMESPACE

    enum class ButtonType {
        Type_Default = 0,
        Type_Primary = 1
    };

    enum class ButtonShape {
        Shape_Default = 0,
        Shape_Circle = 1
    };

    Q_ENUM_NS(ButtonType);
    Q_ENUM_NS(ButtonShape);

    QML_NAMED_ELEMENT(DelButtonType);
}

int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

    qmlRegisterNamespaceAndRevisions(&DelButtonType::staticMetaObject, "DelegateUI.Controls", 1);

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

#include "main.moc"
