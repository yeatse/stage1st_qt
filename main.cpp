#include <QtGui/QApplication>
#include <QDeclarativeEngine>
#include <QDeclarativeContext>

#include "qmlapplicationviewer.h"
#include "networkaccessmanagerfactory.h"
#include "qmlapi.h"

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QScopedPointer<QApplication> app(createApplication(argc, argv));

    app->setApplicationName("stage1st");
    app->setOrganizationName("Yeatse");
    app->setApplicationVersion(VER);

    QScopedPointer<QmlApplicationViewer> viewer(new QmlApplicationViewer);

    QScopedPointer<NetworkAccessManagerFactory> factory(new NetworkAccessManagerFactory);
    viewer->engine()->setNetworkAccessManagerFactory(factory.data());

    viewer->rootContext()->setContextProperty("qmlApi", new QmlApi(viewer.data()));

    viewer->setMainQmlFile(QLatin1String("qml/stage1st/main.qml"));
    viewer->showExpanded();

    return app->exec();
}
