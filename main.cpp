#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "qmlinterface.h"
#include "qmlstandarditemmodel.h"
#include "qmlsortfilterproxymodel.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    // qmlModelAllChannels  -> filter Àû¿ë m_qmlModelTxChannels, m_qmlModelRxChannels

    QmlInterface* m_qmlInterface = new QmlInterface();
    QmlStandardItemModel* m_qmlModelRegisteredTxChannels = new QmlStandardItemModel();
    QmlStandardItemModel* m_qmlModelGroups               = new QmlStandardItemModel();
    QmlStandardItemModel* m_qmlModelMacros               = new QmlStandardItemModel();
    QmlStandardItemModel* m_qmlModelAllZones             = new QmlStandardItemModel();
    QmlStandardItemModel* m_qmlModelTxZones              = new QmlStandardItemModel();
    QmlStandardItemModel* m_qmlModelRxZones              = new QmlStandardItemModel();
    QmlStandardItemModel* m_qmlModelNetworkInterfaces    = new QmlStandardItemModel();

    QQmlApplicationEngine engine;
    QQmlContext* rootContext =  engine.rootContext();

    rootContext->setContextProperty("qmlModelRegisteredTxChannels", m_qmlModelRegisteredTxChannels);
    rootContext->setContextProperty("qmlModelGroups", m_qmlModelGroups);
    rootContext->setContextProperty("qmlModelMacros", m_qmlModelMacros);
    rootContext->setContextProperty("qmlModelAllZones", m_qmlModelAllZones);
    rootContext->setContextProperty("qmlModelTxZones", m_qmlModelTxZones);
    rootContext->setContextProperty("qmlModelRxZones", m_qmlModelRxZones);
    rootContext->setContextProperty("cppInterface", m_qmlInterface);
    rootContext->setContextProperty("qmlModelNetworkInterfaces", m_qmlModelNetworkInterfaces );

    engine.load(QUrl(QStringLiteral("qml/Main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
