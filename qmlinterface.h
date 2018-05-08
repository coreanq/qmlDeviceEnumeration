#ifndef QMLINTERFACE_H
#define QMLINTERFACE_H

//#define DEBUG_QMLINTERFACE_H


#include <QObject>
#include <QProcess>
#include <QMutex>
#include <Qtimer>
#include <QNetworkInterface>
#include <QNetworkAddressEntry>
#include <QSettings>
#include <QDir>
#include <QValidator>
#include <QDate>


#include <QDebug>
#include "qmlstandarditemmodel.h"
#include "qmlsortfilterproxymodel.h"


class QmlInterface : public QObject
{
    Q_OBJECT
public:

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
    enum {
        INDEX_QML_GROUPS_ID,
        INDEX_QML_GROUPS_NAME,
        INDEX_QML_GROUPS_SOURCE,
        INDEX_QML_GROUPS_RXDANTENAMELIST,
        INDEX_QML_GROUPS_RXCHANNELLIST,
        INDEX_QML_GROUPS_SELECTED,
        INDEX_QML_GROUPS_PROCESSING,
        INDEX_QML_GROUPS_COUNT
    };

    enum {
        INDEX_QML_NETWORK_INTERFACES_NAME,
        INDEX_QML_NETWORK_INTERFACES_IP,
        INDEX_QML_NETWORK_INTERFACES_NETMASK,
        INDEX_QML_NETWORK_INTERFACES_MAC,
        INDEX_QML_NETWORK_INTERFACES_LINKSPEED,
        INDEX_QML_NETWORK_INTERFACES_ISUP,
        INDEX_QML_NETWORK_INTERFACES_NETWORK_INTERFACE_INDEX, // dante 에서 사용되는 network card index 를 지칭함.
        INDEX_QML_NETWORK_INTERFACES_SELECTED,
        INDEX_QML_NETWORKINTERFACES_COUNT
    };


public:
    explicit QmlInterface(QObject *parent = 0);
    ~QmlInterface();
    void initQmlModel();
    void initQmlZonesModel();
    void initQmlGroupsModel();
    void initRegisteredTxZonesModel();
    void initQmlNetworkInterfacesModel();


    QmlStandardItemModel* modelRegisteredTxChannels() { return m_qmlModelRegisteredTxChannels; }
    QmlStandardItemModel* modelGroups() { return m_qmlModelGroups; }
    QmlStandardItemModel* modelMacros() { return m_qmlModelMacros; }
    QmlStandardItemModel* modelAllZones() { return m_qmlModelAllZones; }
    QmlStandardItemModel* modelNetworkInterfaces() { return m_qmlModelNetworkInterfaces; }
    QmlSortFilterProxyModel* modelTxZones() { return m_qmlModelTxZones; }
    QmlSortFilterProxyModel* modelRxZones(){ return m_qmlModelRxZones; }


    // for qml <-> c++

    Q_INVOKABLE bool isVisibleVK(QString imageName);
    Q_INVOKABLE void showVirtualKeyboard(bool show );

    Q_INVOKABLE void setGroupSelected(int row);
    Q_INVOKABLE void removeGroups(int row);

    Q_INVOKABLE void setRxZoneAllSelected(bool selected);
    Q_INVOKABLE void setRxZoneSelected(QString danteName, QString channelNo, QString selected);
    Q_INVOKABLE void setRxZoneSelected(int row);
    Q_INVOKABLE void setRxZoneSelected(int row, bool selected);
    Q_INVOKABLE void setRxZoneDisabled(QString danteName, bool on );

    Q_INVOKABLE void setTxZoneSelected(QString danteName, QString channelNo, bool selected);
    Q_INVOKABLE void setTxZoneSelected(int row, bool selected);
    Q_INVOKABLE void setRegisteredTxZonesSelected(int row);
    Q_INVOKABLE void setZoneRectWidth(int width);
    Q_INVOKABLE void setZoneRectHeight(int height);


    Q_INVOKABLE void setNetworkInterfaceSelected(int row);
    Q_INVOKABLE void refreshNetworkInterfaces();
    Q_INVOKABLE void reloadDevices();


    Q_INVOKABLE QPoint zoneRectSize();

    Q_INVOKABLE void setZoneName(QString deviceType, QString danteName, QString channelNo, QString name);
    Q_INVOKABLE void setDanteName(QString danteName, QString newName);
    Q_INVOKABLE void setGroupName(QString id, QString groupName );

    Q_INVOKABLE void setEnableVirtualKeyboard(bool on);
    Q_INVOKABLE bool isEnableVirtualKeyboard();



    Q_INVOKABLE void insertTxRegisteredZones(int dragIndex, int targetIndex);
    Q_INVOKABLE void moveTxRegisteredZones(int sourceIndex, int dstIndex );
    Q_INVOKABLE void removeTxRegisteredZones(int dragIndex);

    Q_INVOKABLE void onBtnGroupAddClicked();
    Q_INVOKABLE void onBtnGroupRemoveClicked();
    Q_INVOKABLE void onBtnDBDownloadClicked();
    Q_INVOKABLE void onBtnSubsOnClicked();
    Q_INVOKABLE void onBtnSubsOffClicked();
    Q_INVOKABLE void onBtnCheckDeviceInfoClicked();
    Q_INVOKABLE void onBtnLogShowClicked();
    Q_INVOKABLE void onBtnDbManagementClicked();
    QString           firebirdDBInstallLocation();
    Q_INVOKABLE void onBtnDbInitializeClicked();
    Q_INVOKABLE void onBtnDbBackupClicked();
    Q_INVOKABLE void onBtnDbRestoreClicked();





    Q_INVOKABLE void setLoopback(QString danteName, bool on );
    Q_INVOKABLE void onBtnLoopbackOnClicked(int leftRow, int rightRow);
    Q_INVOKABLE void onBtnLoopbackOffClicked(int leftRow, int rightRow);

    Q_INVOKABLE void onBtnSelAllClicked();
    Q_INVOKABLE void onBtnDeselAllClicked();

    Q_INVOKABLE void onTxtDBNameEditingFinished(QString data);
    Q_INVOKABLE void onTxtServerIPEditingFinished(QString data);
    Q_INVOKABLE void onTxtUserNameEditingFinished(QString data);
    Q_INVOKABLE void onTxtPasswordEditingFinished(QString data);

    Q_INVOKABLE QRegExpValidator* ipValidator();


    int rowInRegisteredTxZones(QString danteName, QString channelNo);
    void insertRegisteredTxZonesToDB(QList <QStandardItem*> items);
    void removeRegisteredTxZonesFromDB(QString danteName, QString channelNo);

    // loopback, subs on/off 를 위해 외부에서 사용되는 함수
    QVariantMap AllRxZonesInfo();
    QVariantMap selectedRxZonesInfo();
    QString selectedTxZonesInfo();
    QString loopbackTxInfo();
    QString loopbackRxInfo();



private:

    QmlStandardItemModel*           m_qmlModelRegisteredTxChannels;
    QmlStandardItemModel*           m_qmlModelGroups;
    QmlStandardItemModel*           m_qmlModelMacros;
    QmlStandardItemModel*           m_qmlModelAllZones;
    QmlStandardItemModel*           m_qmlModelNetworkInterfaces;

    QmlSortFilterProxyModel*        m_qmlModelTxZones;
    QmlSortFilterProxyModel*        m_qmlModelRxZones;

    QString                         m_loopbackRxInfo;
    QString                         m_loopbackTxInfo;

signals:

    void sgDBNameChanged(QString str);
    void sgServerIPChanged(QString str);
    void sgUserNameChanged(QString str);
    void sgPasswordChanged(QString str);

    void sgSetDanteName(QString from, QString to );
    // qml 버튼이 눌리면 발생되는 signal
    // qml 에서 직접 signal 을 만들어 사용하는 경우 해당 component 가 등록이 되어야 하기 때문에 불편함.
    void sgBtnSubsOnClicked();
    void sgBtnSubsOffClicked();
    void sgBtnCheckDeviceInfoClicked();
    void sgBtnLoopbackOperationOnClicked();
    void sgBtnLoopbackOperationOffClicked();

    void sgBtnLogShowClicked();
    void sgBtnDbManagementClicked();

    // qml 기타 설정에서 network interface 를 클릭할때 발생하는 시그널
    void sgNetworkInterfaceSelected(QString name, QString macAddr, QString interfaceIndex);

    void sgSetLoopback(QString danteName, bool on ) ;

    // qml 에서 reload 아이콘을 클릭한 경우 browsing API 에 있는 내부 장비리스트를 전부 지우고 다시 검색 하게 함.
    void sgReloadDevices();

    
public slots:
    //conmon manager 에서 current interface 에 대한 정보가 올라오면 실행되는 함수.
    void onCurrentNetworkInterface(QString name, QString macAddr);

    void onDeviceOk(QString danteName);
    void onDeviceError(QString danteName);
    void onIpAddressChanged(QString danteName, QString ip);
    void onRoutingGetNetworkLoopback(QString danteName, bool on);
    void onRoutingGetRxChannelSubscription(QString danteName, int rxChannel, QString subscription);

    // browsing channel 관련 정보 업데이트
    void onAddTxChannel(QString danteName, QString channelNo);
    void onRemoveTxChannel(QString danteName, QString channelNo);
    void onAddTxLabel(QString danteName, QString channelNo, QString labelName);
    void onRemoveTxLabel(QString danteName, QString channelNo, QString labelName);
    void onRemoveDevice(QString danteName);

};

#endif // QMLINTERFACE_H
