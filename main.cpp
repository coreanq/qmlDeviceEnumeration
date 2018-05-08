#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "qmlinterface.h"
#include "qmlstandarditemmodel.h"
#include "qmlsortfilterproxymodel.h"
  // qstandardItemmodel 에서 사용할 컬럼 정의
enum {
    INDEX_QML_ZONES_ID,
    INDEX_QML_ZONES_NAME,
    INDEX_QML_ZONES_DANTENAME,
    INDEX_QML_ZONES_DEVICE_TYPE,
    INDEX_QML_ZONES_CHANNELNO,
    INDEX_QML_ZONES_PRIMARYIP,
    INDEX_QML_ZONES_SECONDARYIP,
    INDEX_QML_ZONES_SELECTED,
    INDEX_QML_ZONES_LOOPBACK,
    INDEX_QML_ZONES_CONNECTION,
    INDEX_QML_ZONES_COLOR,
    INDEX_QML_ZONES_DISABLED,
    INDEX_QML_ZONES_TXLABELS,
    INDEX_QML_ZONES_RXVOLUME,
    INDEX_QML_ZONES_RXSUBSCRIPTION,
    INDEX_QML_ZONES_RXPROCESSING,
    INDEX_QML_ZONES_COUNT

};
int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    // qmlModelAllChannels  -> filter 적용 m_qmlModelTxChannels, m_qmlModelRxChannels

    QmlInterface* m_qmlInterface = new QmlInterface();
    QmlStandardItemModel* m_qmlModelRegisteredTxChannels = new QmlStandardItemModel();
    QmlStandardItemModel* m_qmlModelGroups               = new QmlStandardItemModel();
    QmlStandardItemModel* m_qmlModelMacros               = new QmlStandardItemModel();
    QmlStandardItemModel* m_qmlModelAllZones             = new QmlStandardItemModel();
    QmlSortFilterProxyModel* m_qmlModelTxZones              = new QmlSortFilterProxyModel();
    QmlSortFilterProxyModel* m_qmlModelRxZones              = new QmlSortFilterProxyModel();
    QmlStandardItemModel* m_qmlModelNetworkInterfaces    = new QmlStandardItemModel();
    QString m_qmlAssetsPath  = "../image/";
    
   // rx channel update 
    QString data = "";
    QList <QStandardItem*> items;
    
    for ( int i = 0; i < 10; i ++ ) {
        for ( int j = 0 ; j < INDEX_QML_ZONES_COUNT ; j ++ )
        {
            switch( j )
            {
            case INDEX_QML_ZONES_NAME:
            {
                data = QString("zone %1").arg(i);
            }
                break;
            case INDEX_QML_ZONES_DANTENAME:
                data = QString("name %1").arg(i);
                break;
            case INDEX_QML_ZONES_DEVICE_TYPE:
                data = "RX";
                break;
            case INDEX_QML_ZONES_CHANNELNO:
                data = 3;
                break;
            case INDEX_QML_ZONES_PRIMARYIP:
                data = "192.168.0.1";
                break;
            case INDEX_QML_ZONES_SECONDARYIP:
                data = "No";
                break;
            case INDEX_QML_ZONES_SELECTED:
                data = "false";
                break;
            case INDEX_QML_ZONES_LOOPBACK:
                data = "false";
                break;
            case INDEX_QML_ZONES_CONNECTION:
                data = "true";
                break;
            case INDEX_QML_ZONES_COLOR:
                // 장비 이름을 합쳐서 특정 컬러 값을 만듬.
            {
                char checksum = 0x00;
                // 최대 100대를 가정햇으므로
                data = QString("#99%1%1")
                        .arg( (quint8(checksum) % 100) * 5, 2, 16,  QChar('0') );
    
            }
                break;
            case INDEX_QML_ZONES_DISABLED:
                data = "false";
                break;
            case INDEX_QML_ZONES_TXLABELS:
                data = "";
                break;
            case INDEX_QML_ZONES_RXVOLUME:
                data = "0";
                break;
            case INDEX_QML_ZONES_RXSUBSCRIPTION:
                data = "";
                break;
            case INDEX_QML_ZONES_RXPROCESSING:
                data = "false";
                break;
            default:
                data = "test";
                break;
            }
                items << new QStandardItem(data); 
        }
//        items.removeAt(0);
        m_qmlModelAllZones->appendRow(items);
//        foreach( QStandardItem* item, items){
//            qDebug() << item->text();
//        }
        items.clear();
    }
  
    QStringList headerData; 
    headerData << "ID" << "Name" << "DanteName" << "DeviceType" << "ChannelNo" << "PrimaryIP" <<
    "SecondaryIP" << "Selected" << "Loopback" << "Connection" << "Color" << "Disabled" << 
    "TxLabels" << "RxVolume" << "RxSubscription" << "RxProcessing"; 
    m_qmlModelAllZones->setHorizontalHeaderLabels(headerData);
    m_qmlModelAllZones->applyRoles();

    m_qmlModelTxZones->setFilterRegExp("TX");
    m_qmlModelTxZones->setFilterKeyColumn( INDEX_QML_ZONES_DEVICE_TYPE );
    m_qmlModelTxZones->setSourceModel(m_qmlModelAllZones);
    m_qmlModelTxZones->applyRoles();

    m_qmlModelRxZones->setFilterRegExp("RX");
    m_qmlModelRxZones->setFilterKeyColumn( INDEX_QML_ZONES_DEVICE_TYPE );
    m_qmlModelRxZones->setSourceModel(m_qmlModelAllZones);
    m_qmlModelRxZones->applyRoles();
    
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
    rootContext->setContextProperty("qmlAssetsPath", m_qmlAssetsPath );

 
    
    engine.load(QUrl(QStringLiteral("qml/Main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
