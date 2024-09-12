#include "editorimagehelper.h"

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    app.setOrganizationName("mengps");
    app.setOrganizationDomain("mengps.utils");

    qmlRegisterType<EditorImageHelper>("an.utils", 1, 0, "EditorImageHelper");

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("Api", new Api);
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}

