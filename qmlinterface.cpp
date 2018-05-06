#include "qmlinterface.h"

QmlInterface::QmlInterface(QObject *parent) :
    QObject(parent),

    m_qmlModelRegisteredTxChannels(new QmlStandardItemModel(this)),
    m_qmlModelGroups            (new QmlStandardItemModel(this)),
    m_qmlModelMacros            (new QmlStandardItemModel(this)),
    m_qmlModelNetworkInterfaces        (new QmlStandardItemModel(this)),

    m_qmlModelAllZones          (new QmlStandardItemModel(this)),
    m_qmlModelTxZones           (new QmlSortFilterProxyModel(this)),
    m_qmlModelRxZones           (new QmlSortFilterProxyModel(this)),

    m_loopbackRxInfo(""),
    m_loopbackTxInfo("")

{
     initQmlModel();
}

QmlInterface::~QmlInterface()
{
    showVirtualKeyboard(false);
}

void QmlInterface::initQmlModel()
{
    initQmlZonesModel();
    initQmlGroupsModel();
    initQmlNetworkInterfacesModel();
    initRegisteredTxZonesModel();
}


// browsing ���� ���� �˻��� ä�� ������ ������.
void QmlInterface::initQmlZonesModel()
{
    QStringList headerData;
    // 1��° value �� column �̸��� ������.
//        headerData << query.value(1).toString();

    m_qmlModelRegisteredTxChannels->setHorizontalHeaderLabels(headerData);
    m_qmlModelRegisteredTxChannels->applyRoles();

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
}


// remotedb ���� ���� groups �����͸� qmlModelGroups �� ��ȯ
void QmlInterface::initQmlGroupsModel()
{
    QStringList headerData;
    // 1��° value �� column �̸��� ������.
//        headerData << query.value(1).toString();
    m_qmlModelGroups->setHorizontalHeaderLabels(headerData);
    m_qmlModelGroups->applyRoles();


    ////////////////////////////////////////////////////////////////////////////
    // remote �ҽ� ���� �ϰ�, local �� ����� �� �����ʹ� ������ �ʵ��� ��.
    QList <int> rowIndexes;
    QList <QStandardItem*> sourceItems;
    sourceItems = m_qmlModelGroups->findItems("REMOTE", Qt::MatchExactly, INDEX_QML_GROUPS_SOURCE );

    foreach ( QStandardItem* item, sourceItems )
    {
        rowIndexes << item->row();
    }

    // desending order �� sort
    qSort(rowIndexes.begin(), rowIndexes.end() , qGreater<int> () );

    foreach (int row, rowIndexes )
    {
        m_qmlModelGroups->removeRow(row);
    }

    QList <QStandardItem*> items;
    //// LOCAL Group �߰�
    items.clear();


#if 0
    while( query.next() )
    {
        for ( int i = 0; i < INDEX_QML_GROUPS_COUNT; i++ )
        {
            QString text = "";
            switch( i )
            {
            case INDEX_QML_GROUPS_ID:
                text = query.value(INDEX_QML_GROUPS_ID).toString();
                break;
            case INDEX_QML_GROUPS_NAME:
                text = query.value(INDEX_QML_GROUPS_NAME).toString();
                break;
            case INDEX_QML_GROUPS_SOURCE:
                text = query.value(INDEX_QML_GROUPS_SOURCE).toString();
                break;
            case INDEX_QML_GROUPS_RXDANTENAMELIST:
                text = query.value(INDEX_QML_GROUPS_RXDANTENAMELIST).toString();
                break;
            case INDEX_QML_GROUPS_RXCHANNELLIST:
                text = query.value(INDEX_QML_GROUPS_RXCHANNELLIST).toString();
                break;
            case INDEX_QML_GROUPS_SELECTED:
                text = "false";
                break;
            case INDEX_QML_GROUPS_PROCESSING:
                text = "false";
                break;
            }
            items << new QStandardItem(text);
        }

        m_qmlModelGroups->appendRow(items);
        items.clear();
    }
#endif
}


void QmlInterface::initQmlNetworkInterfacesModel()
{

#if 0
    enum {
        INDEX_QML_INTERFACES_NAME,
        INDEX_QML_INTERFACES_IP,
        INDEX_QML_INTERFACES_NETMASK,
        INDEX_QML_INTERFACES_MAC,
        INDEX_QML_INTERFACES_LINKSPEED,
        INDEX_QML_INTERFACES_ISUP,
        INDEX_QML_INTERFACES_COUNT
    };
#endif

    QStringList headerData;
    headerData << "Name" <<
                  "IP" <<
                  "Netmask" <<
                  "MAC" <<
                  "LinkSpeed" <<
                  "IsUp"  <<
                  "NetworkIndex" <<
                  "Selected";

    // 1��° value �� column �̸��� ������.
    m_qmlModelNetworkInterfaces->setHorizontalHeaderLabels(headerData);
    m_qmlModelNetworkInterfaces->applyRoles();

}

void QmlInterface::onAddTxChannel(QString danteName, QString channelNo)
{
    // browsing ������ ä�� ������ tx �� ������ �̰� ���� rx/ tx ä�� ������ ��.
    QString data = "";
    QList <QStandardItem*> items;
    bool isDuplicate =false;


    // �̹� ��� �Ǿ� �ִ��� �ߺ� üũ
    QList <int> danteNameRows;
    QList <QStandardItem*> danteNameItems;

    danteNameItems = m_qmlModelAllZones->findItems(danteName, Qt::MatchExactly, INDEX_QML_ZONES_DANTENAME);
    foreach(QStandardItem* danteNameItem, danteNameItems)
    {
        danteNameRows << danteNameItem->row();
    }

    foreach(int row, danteNameRows)
    {
        // ��ϵ� ä���� �̹� ���� �ϴ� ��� connection ���¸� ����. RX, TX ä�� ��� �����ؾ���.
        if( channelNo.toInt() == m_qmlModelAllZones->item(row, INDEX_QML_ZONES_CHANNELNO)->text().toInt() )
        {
            isDuplicate = true;
            m_qmlModelAllZones->item(row, INDEX_QML_ZONES_CONNECTION)->setText("true");
        }
    }

    if( isDuplicate == true )
        return;


    // database �� �˻��Ͽ� �ش� ä���� zone �̸��� �����Ǿ� �ִ��� �ľ�.
    QString txChannelName = "";
    QString rxChannelName = "";

    QString queryString = "";



    // rx tx �̱� ������ �ι� ������ ����.
    for ( int i = 0 ; i < 2 ; i ++ )
    {       
        for ( int j = 0 ; j < INDEX_QML_ZONES_COUNT ; j ++ )
        {
            switch( j )
            {
            case INDEX_QML_ZONES_NAME:
            {
                // ä�� �̸��� ���� ��� default zone name �� �ֵ��� ��.
                if( i == 0 )
                    data = txChannelName.isEmpty() == true ? channelNo + "@" + danteName : txChannelName;
                else
                    data = rxChannelName.isEmpty() == true ? channelNo + "@" + danteName : rxChannelName;
            }
                break;
            case INDEX_QML_ZONES_DANTENAME:
                data = danteName;
                break;
            case INDEX_QML_ZONES_DEVICE_TYPE:
                if( i == 0 )
                    data = "TX";
                else
                    data = "RX";
                break;
            case INDEX_QML_ZONES_CHANNELNO:
                data = channelNo;
                break;
            case INDEX_QML_ZONES_PRIMARYIP:
                data = "";
                break;
            case INDEX_QML_ZONES_SECONDARYIP:
                data = "";
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
                // ��� �̸��� ���ļ� Ư�� �÷� ���� ����.
            {
                char checksum = 0x00;
                for ( int i = 0; i < danteName.count() ; i ++ )
                {
                    checksum += danteName.toLatin1().at(i);
                }
                // �ִ� 100�븦 ���������Ƿ�
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
                data = "NULL";
                break;
            }
            items << new QStandardItem(data);
        }

        QList <QStandardItem*> searchedItems = m_qmlModelAllZones->findItems(danteName, Qt::MatchExactly,  INDEX_QML_ZONES_DANTENAME);
        QList <int> searchedRows ;
        int searchedRow = -1;

        // ä�� ��ȣ�� �°� ������� �����͸� �ֱ� ����.
        foreach ( QStandardItem* searchedItem, searchedItems )
        {
            searchedRows << searchedItem->row();
        }
        // �Ųٷ� �����Ͽ� �ڿ��� ���� �˻� �ϵ��� ��.
        qSort(searchedRows.begin(), searchedRows.end(), qGreater<int>() );


        foreach ( searchedRow, searchedRows )
        {
            if( channelNo.toInt() > m_qmlModelAllZones->item(searchedRow, INDEX_QML_ZONES_CHANNELNO)->text().toInt() )
                break;
        }

        if( searchedRow == -1 )
        {
//            qDebug() << type << "appendRow" << danteName << channelNo << searchedRow;
            m_qmlModelAllZones->appendRow(items);
        }
        else
        {
            m_qmlModelAllZones->insertRow(searchedRow, items);
        }


        items.clear();
    }


    // registered �� tx �� ã�� registered �Ǿ� �ִ� ��� txZones selected ���·� ����.
    if( rowInRegisteredTxZones(danteName, channelNo) != -1)
        setTxZoneSelected(danteName, channelNo, true);

}

int QmlInterface::rowInRegisteredTxZones(QString danteName, QString channelNo)
{
    QList <int> danteNameRows;
    QList <QStandardItem*> items;

    items = m_qmlModelRegisteredTxChannels->findItems(danteName, Qt::MatchExactly, INDEX_QML_ZONES_DANTENAME);
    foreach(QStandardItem* item, items)
    {
        danteNameRows << item->row();
    }

    foreach(int row, danteNameRows)
    {
        if( channelNo.toInt() == m_qmlModelRegisteredTxChannels->item(row, INDEX_QML_ZONES_CHANNELNO)->text().toInt() )
        {
            return row;
        }
    }
    return -1;
}


void QmlInterface::onRemoveTxChannel(QString danteName, QString channelName)
{
    // allZone ���� �ش� ä�� ����.
    QList <QStandardItem*> danteNameItems;
    danteNameItems = m_qmlModelAllZones->findItems(danteName, Qt::MatchExactly, INDEX_QML_ZONES_DANTENAME );

    QList <int> rows;

    foreach( QStandardItem* danteNameItem, danteNameItems)
    {
        rows << danteNameItem->row();
    }

    // desending order �� ����
    qSort(rows.begin(), rows.end(), qGreater<int>() );

    // rx zone tx zone ��� ������ �ϹǷ�
    foreach( int row, rows )
    {
        QStandardItem* item = m_qmlModelAllZones->item(row, INDEX_QML_ZONES_CHANNELNO );
        if( item->text().toInt() == channelName.toInt() )
        {
            m_qmlModelAllZones->removeRow(row);
        }
    }

//    // txRegistered ���� �ش� ä�� ����

//    rows.clear();
//    danteNameItems = m_qmlModelRegisteredTxChannels->findItems(danteName, Qt::MatchExactly, INDEX_QML_ZONES_DANTENAME );
//    foreach( QStandardItem* danteNameItem, danteNameItems)
//    {
//        rows << danteNameItem->row();
//    }
//    // desending order �� ����
//    qSort(rows.begin(), rows.end(), qGreater<int>() );

//    foreach( int row, rows )
//    {
//        QStandardItem* item = m_qmlModelRegisteredTxChannels->item(row, INDEX_QML_ZONES_CHANNELNO );
//        if( item->text().toInt() == channelName.toInt() )
//        {
//            removeTxRegisteredZones(row);
//        }
//    }

}
void QmlInterface::onAddTxLabel(QString danteName, QString channelNo, QString labelName)
{
    QList <QStandardItem*> danteNameItems;
    danteNameItems = m_qmlModelAllZones->findItems(danteName, Qt::MatchExactly, INDEX_QML_ZONES_DANTENAME );

    QList <int> rowIndexes;
    foreach( QStandardItem* danteNameItem, danteNameItems)
    {
        rowIndexes << danteNameItem->row();
    }

    foreach( int rowIndex, rowIndexes )
    {
        QStandardItem* channelNoItem = m_qmlModelAllZones->item(rowIndex, INDEX_QML_ZONES_CHANNELNO );
        if( channelNoItem->text().toInt() == channelNo.toInt() )
        {
            QStandardItem* labelItem = m_qmlModelAllZones->item(rowIndex, INDEX_QML_ZONES_TXLABELS );

            if( labelItem->text().isEmpty() == true  )
            {
                labelItem->setText( labelName );
            }
            else {
                labelItem->setText( labelItem->text() + "," + labelName );
            }
        }
    }

}
void QmlInterface::onRemoveTxLabel(QString danteName, QString channelNo, QString labelName)
{
    QList <QStandardItem*> danteNameItems;
    danteNameItems = m_qmlModelAllZones->findItems(danteName, Qt::MatchExactly, INDEX_QML_ZONES_DANTENAME );

    QList <int> rowIndexes;
    foreach( QStandardItem* danteNameItem, danteNameItems)
    {
        rowIndexes << danteNameItem->row();
    }

    foreach( int rowIndex, rowIndexes )
    {
        QStandardItem* channelNoItem = m_qmlModelAllZones->item(rowIndex, INDEX_QML_ZONES_CHANNELNO );
        if( channelNoItem->text() == channelNo )
        {
            QStandardItem* labelItem = m_qmlModelAllZones->item(rowIndex, INDEX_QML_ZONES_TXLABELS );
            QStringList labelList = labelItem->text().split(",", QString::SkipEmptyParts );

            labelList.removeAt( labelList.indexOf(labelName) );
            labelItem->setText( labelList.join(",") );
            return;
        }
    }
}

void QmlInterface::onRemoveDevice(QString danteName)
{
#ifdef DEBUG_QMLINTERFACE_H
    qDebug() << Q_FUNC_INFO << danteName;
#endif
    QList <QStandardItem* > items;
    QList <int> rows;
    items = m_qmlModelAllZones->findItems( danteName, Qt::MatchExactly, INDEX_QML_ZONES_DANTENAME);

    foreach ( QStandardItem* item , items)
    {
        rows << item->row();
    }

    qSort(rows.begin(), rows.end(),  qGreater<int>()  );

    foreach( int row, rows )
    {
        m_qmlModelAllZones->removeRow(row);
    }
}

void QmlInterface::onDeviceOk(QString danteName)
{
#ifdef DEBUG_QMLINTERFACE_H
    qDebug() << Q_FUNC_INFO << danteName;
#endif

    QList <QStandardItem* > items;
    items = m_qmlModelAllZones->findItems( danteName, Qt::MatchExactly, INDEX_QML_ZONES_DANTENAME);

    foreach ( QStandardItem* item , items)
    {
        QStandardItem* targetItem = m_qmlModelAllZones->item(item->row(), INDEX_QML_ZONES_CONNECTION);
        if( targetItem != 0 )
        {
            targetItem->setText("true");
        }
    }

    items =  m_qmlModelRegisteredTxChannels->findItems( danteName, Qt::MatchExactly, INDEX_QML_ZONES_CONNECTION );

    foreach ( QStandardItem* item , items)
    {
        QStandardItem* targetItem = m_qmlModelRegisteredTxChannels->item(item->row(), INDEX_QML_ZONES_CONNECTION);
        if( targetItem != 0 )
        {
            targetItem->setText("true");
        }
    }
}

void QmlInterface::onDeviceError(QString danteName)
{
    QList <QStandardItem* > items;
    items = m_qmlModelAllZones->findItems( danteName, Qt::MatchExactly, INDEX_QML_ZONES_DANTENAME);

    foreach ( QStandardItem* item , items)
    {
        QStandardItem* targetItem = m_qmlModelAllZones->item(item->row(), INDEX_QML_ZONES_CONNECTION);
        if( targetItem != 0 )
        {
            targetItem->setText("false");
        }
    }

    items =  m_qmlModelRegisteredTxChannels->findItems( danteName, Qt::MatchExactly, INDEX_QML_ZONES_CONNECTION );

    foreach ( QStandardItem* item , items)
    {
        QStandardItem* targetItem = m_qmlModelRegisteredTxChannels->item(item->row(), INDEX_QML_ZONES_CONNECTION);
        if( targetItem != 0 )
        {
            targetItem->setText("false");
        }
    }
}

void QmlInterface::onIpAddressChanged(QString danteName, QString ip)
{
#ifdef DEBUG_QMLINTERFACE_H
    qDebug() << Q_FUNC_INFO << ip;
#endif

    QList <int> rows;
    QList <QStandardItem* > items;
    items = m_qmlModelAllZones->findItems( danteName, Qt::MatchExactly, INDEX_QML_ZONES_DANTENAME );

    foreach ( QStandardItem* item , items)
    {
        rows << item->row();
    }

    foreach(int row, rows)
    {
        QStandardItem* primaryIpItem = m_qmlModelAllZones->item(row, INDEX_QML_ZONES_PRIMARYIP );
        primaryIpItem->setText(ip);
    }
}


void QmlInterface::onRoutingGetNetworkLoopback(QString danteName, bool on)
{
#ifdef DEBUG_QMLINTERFACE_H
    qDebug() << Q_FUNC_INFO << danteName << "rxChannel" << "loopback" << on;
#endif

    QList <int> rows;
    QList <QStandardItem* > items;
    items = m_qmlModelAllZones->findItems( danteName, Qt::MatchExactly, INDEX_QML_ZONES_DANTENAME );

    foreach ( QStandardItem* item , items)
    {
        rows << item->row();
    }

    foreach(int row, rows)
    {
        QStandardItem* loopbackItem = m_qmlModelAllZones->item(row, INDEX_QML_ZONES_LOOPBACK );
        if( on == true )
            loopbackItem->setText("true");
        else
            loopbackItem->setText("false");
    }
}
void QmlInterface::onRoutingGetRxChannelSubscription(QString danteName, int rxChannel, QString subscription)
{
#ifdef DEBUG_QMLINTERFACE_H
    qDebug() << Q_FUNC_INFO << danteName << "rxChannel" << rxChannel << "Subscription " << subscription;
#endif

    QList <int> rows;
    QList <QStandardItem* > items;
    QString queryString = "";



    items = m_qmlModelAllZones->findItems( danteName, Qt::MatchExactly, INDEX_QML_ZONES_DANTENAME );

    foreach ( QStandardItem* item , items)
    {
        rows << item->row();
    }

    foreach(int row, rows)
    {
        QStandardItem* subsItem = m_qmlModelAllZones->item(row, INDEX_QML_ZONES_RXSUBSCRIPTION );
        QStandardItem* channelNoItem = m_qmlModelAllZones->item(row, INDEX_QML_ZONES_CHANNELNO);
        if( channelNoItem->text().toInt() == rxChannel )
        {
            if( subscription.isEmpty() == true )
            {
                subsItem->setText(subscription);
            }
            else
            {
                QString txDanteName = subscription.split("@", QString::KeepEmptyParts).at(1);
                QString txChannel = subscription.split("@", QString::KeepEmptyParts).at(0);

            }
        }
    }
}



bool QmlInterface::isVisibleVK(QString imageName)
{
#ifdef DEBUG_QMLINTERFACE_H
    qDebug() << Q_FUNC_INFO ;
#endif
    QString program = "cmd.exe";
    QStringList arg;
    arg << QString("/C") << QString("tasklist.exe") << QString("/FI") << QString("IMAGENAME eq %1").arg(imageName);

    QProcess process;
    process.start(program, arg );
    process.waitForFinished();

    QByteArray output = process.readAllStandardOutput();
//    QByteArray error = process.readAllStandardError();
//    qDebug() << QString(output);

    if( QString(output).contains(imageName.toLatin1(), Qt::CaseInsensitive))
        return true;
    else
        return false;
}

void QmlInterface::showVirtualKeyboard(bool show)
{
#ifdef DEBUG_QMLINTERFACE_H
    qDebug() << Q_FUNC_INFO  << show;
#endif

    if( isEnableVirtualKeyboard() == false )
        return;

    QProcess process;
    QStringList killArg, exeArg;
    QString program = "osk.exe";

    killArg << QString("/C") << QString("taskkill.exe") <<  QString("/F") << QString("/IM") << QString("osk.exe");
//    exeArg <<  QString("/C") << QString("osk.exe");

    bool isProcessAlive = isVisibleVK(program);

    if( show )
    {
        // ���� Ű���尡 ����Ǿ� ���� �ʴ� ��츸 ����.
        if ( isProcessAlive == false )
        {
            process.execute(program, exeArg);
        }
    }
    else
    {
        // ���� Ű���尡 ����Ǿ� �ִ� ��츸 ����.
        if ( isProcessAlive == true )
        {
            process.execute("cmd.exe", killArg);
        }
    }
//    qDebug() << killArg << exeArg << program << "show" << show << "isProcessAlive" << isProcessAlive ;
}


// example of input data
// rxchannelList -> dac01:dac02..
// rxChannelList -> 1,2,3:4,5...
void QmlInterface::setGroupSelected(int row )
{
#ifdef DEBUG_QMLINTERFACE_H
    qDebug() << Q_FUNC_INFO  << row;
#endif

    if( row == -1 )
        return;

    QString rxDanteNameList = "";
    QString rxChannelList = "";

    QStandardItem* item = m_qmlModelGroups->item(row, INDEX_QML_GROUPS_ID);
    QString id = item->text();


//    qDebug() << Q_FUNC_INFO  << row  << id << rxDanteNameList << rxChannelList;

    // group selecting
    item = m_qmlModelGroups->item(row, INDEX_QML_GROUPS_SELECTED);

    if( item->text() == "true" )
    {
        item->setText("false");
    }
    else
    {
        item->setText("true");
    }
    qDebug() << rxChannelList;

    // �ش� zone selecting
    QStringList rxDanteNames = rxDanteNameList.split(":", QString::SkipEmptyParts );
    QStringList rxChannels = rxChannelList.split(":", QString::SkipEmptyParts );

    for ( int i = 0 ;  i < rxDanteNames.count() ; i ++ )
    {
        QString rxDanteName = rxDanteNames.at(i);
        QStringList rxChannelNoList = rxChannels.at(i).split(",", QString::SkipEmptyParts);

        foreach( QString rxChannel, rxChannelNoList)
        {
//            qDebug() << rxDanteName << rxChannel << selected;
            setRxZoneSelected(rxDanteName, rxChannel, item->text());
        }
    }
}


void QmlInterface::removeGroups(int row)
{
#ifdef DEBUG_QMLINTERFACE_H
    qDebug() << Q_FUNC_INFO << row;
#endif

    QString queryString;

    QString id = "";

    if( row != -1 )
    {
        id = m_qmlModelGroups->index(row , INDEX_QML_GROUPS_ID).data().toString();
        m_qmlModelGroups->removeRow(row);
    }
}



// ��ۿ�
void QmlInterface::setRxZoneSelected(int row)
{
#ifdef DEBUG_QMLINTERFACE_H
    qDebug() << Q_FUNC_INFO;
#endif
    if ( row == -1 )
        return;

    QModelIndex index = m_qmlModelRxZones->index(row, INDEX_QML_ZONES_SELECTED);
    QString data = m_qmlModelRxZones->data(index, Qt::EditRole).toString();
    if( data == "true" )
        m_qmlModelRxZones->setData(index, "false");
    else
        m_qmlModelRxZones->setData(index, "true");
 }


void QmlInterface::setRxZoneAllSelected(bool selected)
{
#ifdef DEBUG_QMLINTERFACE_H
    qDebug() << Q_FUNC_INFO <<  selected;
#endif
    for ( int i = 0; i < m_qmlModelRxZones->rowCount() ; i ++ )
    {
        QModelIndex index = m_qmlModelRxZones->index(i, INDEX_QML_ZONES_SELECTED);
        if( selected )
            m_qmlModelRxZones->setData(index, "true");
        else
            m_qmlModelRxZones->setData(index, "false");
    }
}

void QmlInterface::setRxZoneSelected(int row, bool selected)
{

#ifdef DEBUG_QMLINTERFACE_H
    qDebug() << Q_FUNC_INFO << row << selected;
#endif
    if ( row == -1 )
        return;

    QModelIndex index = m_qmlModelRxZones->index(row, INDEX_QML_ZONES_SELECTED);
    if( selected )
        m_qmlModelRxZones->setData(index, "true");
    else
        m_qmlModelRxZones->setData(index, "false");
 }


void QmlInterface::setRxZoneSelected(QString danteName, QString rxChannel, QString selected)
{
#ifdef DEBUG_QMLINTERFACE_H
    qDebug() << Q_FUNC_INFO << danteName << rxChannel << selected;
#endif

    QList <QStandardItem*> danteNameItems = m_qmlModelAllZones->findItems(danteName, Qt::MatchExactly, INDEX_QML_ZONES_DANTENAME);
    QList <int> rows;

    foreach (QStandardItem* item, danteNameItems)
    {
        rows << item->row();
    }

    foreach(int row , rows)
    {
        // channel �� ��� 01, 1 �̷������� �ü� �ֱ� ������ string �񱳴� ���� �ʴ´�.
        int channel = m_qmlModelAllZones->item(row, INDEX_QML_ZONES_CHANNELNO)->text().toInt();
        QString type   = m_qmlModelAllZones->item(row, INDEX_QML_ZONES_DEVICE_TYPE)->text();

//        qDebug() << danteName << channel << type << rxDanteName << rxChannel << selected;

        if( channel == rxChannel.toInt() && type == "RX" )
        {
            QStandardItem* selectedItem = m_qmlModelAllZones->item(row, INDEX_QML_ZONES_SELECTED);
            selectedItem->setText(selected);
        }
    }
}


void QmlInterface::setRxZoneDisabled(QString danteName, bool on )
{
#ifdef DEBUG_QMLINTERFACE_H
    qDebug() << Q_FUNC_INFO << danteName << on;
#endif

    // ������ disabled �Ǿ��� �� ���� ���� �ؾ� �ǹǷ� ��ü�� �˻��ؾ���.
    for( int i = 0;  i < m_qmlModelAllZones->rowCount(); i ++)
    {
        QString targetDanteName = m_qmlModelAllZones->item(i, INDEX_QML_ZONES_DANTENAME)->text();
        QStandardItem* disabledItem = m_qmlModelAllZones->item(i, INDEX_QML_ZONES_DISABLED);
        QString type   = m_qmlModelAllZones->item(i, INDEX_QML_ZONES_DEVICE_TYPE)->text();

        if( type == "RX" )
        {
            if(  targetDanteName == danteName )
            {
                if( on ==  true)
                    disabledItem->setText("true");
                else
                    disabledItem->setText("false");
            }
            else
                disabledItem->setText("false");
        }
    }
}

void QmlInterface::setTxZoneSelected(int row, bool selected)
{
#ifdef DEBUG_QMLINTERFACE_H
    qDebug() << Q_FUNC_INFO ;
#endif

    if ( row == -1 )
        return;

    QModelIndex index = m_qmlModelTxZones->index(row, INDEX_QML_ZONES_SELECTED);
    if( selected )
        m_qmlModelTxZones->setData(index, "true");
    else
        m_qmlModelTxZones->setData(index, "false");
 }



void QmlInterface::setTxZoneSelected(QString danteName, QString channelNo, bool selected)
{
#ifdef DEBUG_QMLINTERFACE_H
    qDebug() << Q_FUNC_INFO << danteName << channelNo << selected;
#endif

    QList <QStandardItem*> danteNameItems = m_qmlModelAllZones->findItems(danteName, Qt::MatchExactly, INDEX_QML_ZONES_DANTENAME);
    QList <int> danteNameRowIndexes;

    foreach (QStandardItem* item, danteNameItems)
    {
        danteNameRowIndexes << item->row();
    }

    foreach(int row , danteNameRowIndexes)
    {
        // channel �� ��� 01, 1 �̷������� �ü� �ֱ� ������ string �񱳴� ���� �ʴ´�.
        QString danteName = m_qmlModelAllZones->item(row, INDEX_QML_ZONES_DANTENAME)->text();
        int channel = m_qmlModelAllZones->item(row, INDEX_QML_ZONES_CHANNELNO)->text().toInt();
        QString type   = m_qmlModelAllZones->item(row, INDEX_QML_ZONES_DEVICE_TYPE)->text();

//        qDebug() << danteName << channel << type << rxDanteName << rxChannel << selected;

        if( danteName == danteName && channel == channelNo.toInt() && type == "TX" )
        {

            QStandardItem* selectedItem = m_qmlModelAllZones->item(row, INDEX_QML_ZONES_SELECTED);
            if( selected == true )
            {
                selectedItem->setText("true");
            }
            else
            {
                selectedItem->setText("false");
            }
        }
    }
 }


void QmlInterface::setRegisteredTxZonesSelected(int row)
{
#ifdef DEBUG_QMLINTERFACE_H
    qDebug() << Q_FUNC_INFO;
#endif

    //RegisteredTxZones �� ��� �ѹ��� �ϳ��� zone �� ������ �����ؾ���.
    QStandardItem* selectedItem = 0;

    for(int i = 0 ; i < m_qmlModelRegisteredTxChannels->rowCount(); i ++ )
    {
        selectedItem = m_qmlModelRegisteredTxChannels->item(i, INDEX_QML_ZONES_SELECTED);
        if( i == row )
        {
            if( selectedItem->text()  == "true" )
            {
                selectedItem->setText("false");
            }
            else
            {
                selectedItem->setText("true");
            }
        }
        else
        {
            if( selectedItem->text()  == "true" )
            {
                selectedItem->setText("false");
            }
        }
    }
}


void QmlInterface::setZoneRectWidth(int width)
{
#ifdef DEBUG_QMLINTERFACE_H
    qDebug() << Q_FUNC_INFO << width;
#endif

}

void QmlInterface::setZoneRectHeight(int height)
{
#ifdef DEBUG_QMLINTERFACE_H
    qDebug() << Q_FUNC_INFO <<  height;
#endif

}


void QmlInterface::onCurrentNetworkInterface(QString name, QString macAddr)
{
#ifdef DEBUG_QMLINTERFACE_H
    qDebug() << Q_FUNC_INFO ;
#endif


    QString interfaceIndex = "";

    for( int i=0; i < m_qmlModelNetworkInterfaces->rowCount() ; i ++ )
    {
        QModelIndex selectedIndex = m_qmlModelNetworkInterfaces->index(i, INDEX_QML_NETWORK_INTERFACES_SELECTED);
        if( macAddr.toUpper() ==
                m_qmlModelNetworkInterfaces->index(i, INDEX_QML_NETWORK_INTERFACES_MAC).data().toString().toUpper() )
        {
            // ���� �����Ϳ��� true �� ������ �� ���
            if( selectedIndex.data().toString() == "false")
            {
                interfaceIndex = m_qmlModelNetworkInterfaces->index(i, INDEX_QML_NETWORK_INTERFACES_NETWORK_INTERFACE_INDEX).data().toString();
                if( interfaceIndex.isEmpty() == true )
                    return;
                m_qmlModelNetworkInterfaces->setData(selectedIndex, "true" );

            }
        }
        else{
            m_qmlModelNetworkInterfaces->setData(selectedIndex, "false" );
        }
    }
}

void QmlInterface::setNetworkInterfaceSelected(int row)
{
#ifdef DEBUG_QMLINTERFACE_H
    qDebug() << Q_FUNC_INFO ;
#endif
    QString macAddr = "";
    QString name = "";
    QString interfaceIndex = "";

    // interface selecting �� ��� selecting �� ��� �ڵ����� �̺�Ʈ�� conmon manager ���� �ö� ���� ������
    // ��� ���� ���� ����.
    for ( int i = 0; i < m_qmlModelNetworkInterfaces->rowCount() ; i ++ )
    {
        if( i == row )
        {
            name = m_qmlModelNetworkInterfaces->index(i, INDEX_QML_NETWORK_INTERFACES_NAME ).data().toString();
            macAddr = m_qmlModelNetworkInterfaces->index(i, INDEX_QML_NETWORK_INTERFACES_MAC).data().toString();    
            interfaceIndex = m_qmlModelNetworkInterfaces->index(i, INDEX_QML_NETWORK_INTERFACES_NETWORK_INTERFACE_INDEX).data().toString();
            emit sgNetworkInterfaceSelected(name, macAddr, interfaceIndex);
        }
    }
}

void QmlInterface::refreshNetworkInterfaces()
{
#ifdef DEBUG_QMLINTERFACE_H
    qDebug() << Q_FUNC_INFO;
#endif

    QModelIndex ipAddrIndex;
    QModelIndex subnetIndex;
    QModelIndex interfaceIndex;
    QString macAddr = "";


    for ( int i = 0; i < m_qmlModelNetworkInterfaces->rowCount() ; i ++ )
    {
        macAddr = m_qmlModelNetworkInterfaces->index(i, INDEX_QML_NETWORK_INTERFACES_MAC).data().toString();
        ipAddrIndex = m_qmlModelNetworkInterfaces->index(i, INDEX_QML_NETWORK_INTERFACES_IP);
        subnetIndex = m_qmlModelNetworkInterfaces->index(i, INDEX_QML_NETWORK_INTERFACES_NETMASK );
        interfaceIndex = m_qmlModelNetworkInterfaces->index(i, INDEX_QML_NETWORK_INTERFACES_NETWORK_INTERFACE_INDEX );

        // qt ���� networkinterface ������ ��� ���°��� dante ���� ������ ������ Ŭ���̳� refresh �� ������ ������ ��� ������ ��.
        foreach( QNetworkInterface interface, QNetworkInterface::allInterfaces() )
        {
            QString tempMacAddr = interface.hardwareAddress().toUpper();
            if( macAddr.toUpper() == tempMacAddr )
            {
                foreach( QNetworkAddressEntry address,   interface.addressEntries() )
                {
                    // ip4 address ���� ����Ʈ�� �߰�.
                    if( address.ip().protocol()  == QAbstractSocket::IPv4Protocol )
                    {
                        m_qmlModelNetworkInterfaces->setData(ipAddrIndex,  address.ip().toString() );
                        m_qmlModelNetworkInterfaces->setData(subnetIndex,  address.netmask().toString() );
                        m_qmlModelNetworkInterfaces->setData(interfaceIndex, interface.index() );
                    }
                }
            }
        }
    }
}

void QmlInterface::reloadDevices()
{
    emit sgReloadDevices();
}



QPoint QmlInterface::zoneRectSize()
{
#ifdef DEBUG_QMLINTERFACE_H
    qDebug() << Q_FUNC_INFO ;
#endif
    QPoint pt;
    return pt;
}



void QmlInterface::setZoneName( QString deviceType, QString danteName, QString channelNo, QString name)
{
#ifdef DEBUG_QMLINTERFACE_H
    qDebug() << Q_FUNC_INFO;
#endif
    // remote db �� �����ؼ� zone �̸� ������Ʈ ������ local db ������Ʈ , memory �󿡼� ���� �ϴ� ���� ������Ʈ ����

    QString queryString;
    int id = -1;

    //remote db update


    // �޸𸮻� ���� �ϴ� DB ������Ʈ
    // RXZONE, TXZONE, REGISTEREDTXZONE
    QList <QStandardItem*> danteNameItems = m_qmlModelAllZones->findItems(danteName, Qt::MatchExactly, INDEX_QML_ZONES_DANTENAME);
    QList <int> rows;

    foreach (QStandardItem* item, danteNameItems)
    {
        rows << item->row();
    }

    foreach(int row , rows)
    {
        // channel �� ��� 01, 1 �̷������� �ü� �ֱ� ������ string �񱳴� ���� �ʴ´�.
        int channel = m_qmlModelAllZones->item(row, INDEX_QML_ZONES_CHANNELNO)->text().toInt();
        QString type   = m_qmlModelAllZones->item(row, INDEX_QML_ZONES_DEVICE_TYPE)->text();

//        qDebug() << danteName << channel << type << rxDanteName << rxChannel << selected;
        if(channel == channelNo.toInt() && type == deviceType )
        {
            QStandardItem* selectedItem = m_qmlModelAllZones->item(row, INDEX_QML_ZONES_NAME);
            selectedItem->setText(name);
        }
    }


    danteNameItems = m_qmlModelRegisteredTxChannels->findItems(danteName, Qt::MatchExactly, INDEX_QML_ZONES_DANTENAME);
    rows.clear();
    foreach (QStandardItem* item, danteNameItems)
    {
        rows << item->row();
    }

    foreach(int row , rows)
    {
        // channel �� ��� 01, 1 �̷������� �ü� �ֱ� ������ string �񱳴� ���� �ʴ´�.
        int channel = m_qmlModelRegisteredTxChannels->item(row, INDEX_QML_ZONES_CHANNELNO)->text().toInt();
        if(channel == channelNo.toInt()  )
        {
            QStandardItem* selectedItem = m_qmlModelRegisteredTxChannels->item(row, INDEX_QML_ZONES_NAME);
            selectedItem->setText(name);
        }
    }

}

void QmlInterface::setDanteName(QString danteName, QString newName)
{
#ifdef DEBUG_QMLINTERFACE_H
    qDebug() << Q_FUNC_INFO << danteName << newName;
#endif
    if( newName.isEmpty()== true )
        return;
    emit sgSetDanteName(danteName, newName);
}


void QmlInterface::setGroupName(QString id, QString groupName )
{
#ifdef DEBUG_QMLINTERFACE_H
    qDebug() << Q_FUNC_INFO << id << groupName;
#endif

    // db �� ���� ���� update ����.

    QList<int> rows;
    QList <QStandardItem*> items = m_qmlModelGroups->findItems(id, Qt::MatchExactly, INDEX_QML_GROUPS_ID );

    foreach( QStandardItem * item, items)
    {
        rows << item->row();
    }

    foreach( int row, rows)
    {
        QStandardItem* nameItem  = m_qmlModelGroups->item(row, INDEX_QML_GROUPS_NAME);
        nameItem->setText(groupName);
    }


}


void QmlInterface::setEnableVirtualKeyboard(bool on)
{
#ifdef DEBUG_QMLINTERFACE_H
    qDebug() << Q_FUNC_INFO << on;
#endif


}

bool QmlInterface::isEnableVirtualKeyboard()
{
#ifdef DEBUG_QMLINTERFACE_H
    qDebug() << Q_FUNC_INFO;
#endif

    return false;
}



void QmlInterface::removeTxRegisteredZones(int dragIndex)
{
#ifdef DEBUG_QMLINTERFACE_H
    qDebug() << Q_FUNC_INFO;
#endif

    QList <QStandardItem*> items;
    if( dragIndex == -1 )
        return;

    QString danteName = "";
    QString channelNo = "";

    danteName = m_qmlModelRegisteredTxChannels->index(dragIndex, INDEX_QML_ZONES_DANTENAME).data().toString();
    channelNo = m_qmlModelRegisteredTxChannels->index(dragIndex, INDEX_QML_ZONES_CHANNELNO).data().toString();

//    qDebug() << "row " << dragIndex << danteName << channelNo << "row count" << m_qmlModelRegisteredTxChannels->rowCount();

    m_qmlModelRegisteredTxChannels->removeRow(dragIndex);
    setTxZoneSelected(danteName, channelNo, false);
    removeRegisteredTxZonesFromDB(danteName, channelNo);
}

void QmlInterface::insertTxRegisteredZones(int dragIndex, int targetIndex)
{
#ifdef DEBUG_QMLINTERFACE_H
    qDebug() << Q_FUNC_INFO;
#endif
//    qDebug() << Q_FUNC_INFO<< dragIndex << targetIndex;
    if( dragIndex == -1 )
        return;

    QList <int> rows;
    QList <QStandardItem*> items;
    QString danteName = m_qmlModelTxZones->index(dragIndex, INDEX_QML_ZONES_DANTENAME).data().toString();
    QString channelNo = m_qmlModelTxZones->index(dragIndex, INDEX_QML_ZONES_CHANNELNO).data().toString();

    items =  m_qmlModelRegisteredTxChannels->findItems(danteName, Qt::MatchExactly , INDEX_QML_ZONES_DANTENAME);

    foreach(QStandardItem* item, items)
    {
        rows << item->row();
    }
    // �ߺ��� �����Ͱ� ���� ��� ���� ����
    foreach (int row , rows)
    {
        QStandardItem* channelNoItem = m_qmlModelRegisteredTxChannels->item(row, INDEX_QML_ZONES_CHANNELNO);
        if( channelNoItem->text() == channelNo)
        {
            return;
        }
    }

    items.clear();

    for ( int i = 0; i < INDEX_QML_ZONES_COUNT; i++ )
    {
        QString text = m_qmlModelTxZones->index(dragIndex, i).data().toString();
//        qDebug() << dragIndex << text;
        switch( i )
        {

        case INDEX_QML_ZONES_DEVICE_TYPE:
            text = "REGISTEREDTX";
            break;
        case INDEX_QML_ZONES_SELECTED:
            text = "false";
            break;
        case INDEX_QML_ZONES_LOOPBACK:
            text = "false";
            break;
        case INDEX_QML_ZONES_CONNECTION:
            text = "true";
            break;
        case INDEX_QML_ZONES_RXSUBSCRIPTION:
            text = "";
            break;
        case INDEX_QML_ZONES_RXPROCESSING:
            text = "false";
            break;
        }
        items << new QStandardItem(text);
    }

    if( targetIndex != -1 )
    {
        m_qmlModelRegisteredTxChannels->insertRow(targetIndex, items);
    }
    else
    {
        m_qmlModelRegisteredTxChannels->appendRow(items);
    }


    setTxZoneSelected(dragIndex, true);
    insertRegisteredTxZonesToDB(items);

}
void QmlInterface::moveTxRegisteredZones(int sourceIndex, int dstIndex )
{
#ifdef DEBUG_QMLINTERFACE_H
    qDebug() << Q_FUNC_INFO;
#endif
    // �ű���� �ϴ� ��ġ�� ���� ��� operation ��
    if( sourceIndex == dstIndex )
        return;

    // dstIndex -1 �� ���� �� ���ܰ迡�� ó�� �Ǳ� ������ ó�� �ϸ� �ȵ�.
    // (���� ���׷� -1 ���� ���� ��� ���� )
    if( dstIndex == -1 )
        return;
    QList< QStandardItem*> rowItems = m_qmlModelRegisteredTxChannels->takeRow(sourceIndex);
    if( dstIndex != -1 )
        m_qmlModelRegisteredTxChannels->insertRow(dstIndex, rowItems);
    else
        m_qmlModelRegisteredTxChannels->appendRow(rowItems);

}

void QmlInterface::initRegisteredTxZonesModel()
{
#ifdef DEBUG_QMLINTERFACE_H
    qDebug() << Q_FUNC_INFO;
#endif
    QList <QStandardItem*> items;


    // �ʱ� ����� registeredTxZone �� �̸��� DeviceChannelInfo ������ ����ȭ ��Ŵ.
    for ( int i = 0 ; i < m_qmlModelRegisteredTxChannels->rowCount(); i++ )
    {
        QString danteName = m_qmlModelRegisteredTxChannels->item(i, INDEX_QML_ZONES_DANTENAME)->text();
        QString channelNo = m_qmlModelRegisteredTxChannels->item(i, INDEX_QML_ZONES_CHANNELNO)->text();
    }
}

QString QmlInterface::loopbackRxInfo()
{
#ifdef DEBUG_QMLINTERFACE_H
    qDebug() << Q_FUNC_INFO;
#endif
    return m_loopbackRxInfo;
}

QString QmlInterface::loopbackTxInfo()
{
#ifdef DEBUG_QMLINTERFACE_H
    qDebug() << Q_FUNC_INFO;
#endif
    return m_loopbackTxInfo;
}



void QmlInterface::insertRegisteredTxZonesToDB(QList <QStandardItem*> items)
{
#ifdef DEBUG_QMLINTERFACE_H
    qDebug() << Q_FUNC_INFO;
#endif

}

void QmlInterface::removeRegisteredTxZonesFromDB(QString danteName, QString channelNo)
{
#ifdef DEBUG_QMLINTERFACE_H
    qDebug() << Q_FUNC_INFO;
#endif
}


void QmlInterface::onBtnGroupAddClicked()
{
#ifdef DEBUG_QMLINTERFACE_H
    qDebug() << Q_FUNC_INFO;
#endif


}

void QmlInterface::onBtnGroupRemoveClicked()
{
#ifdef DEBUG_QMLINTERFACE_H
    qDebug() << Q_FUNC_INFO;
#endif

}





void QmlInterface::onBtnSubsOnClicked()
{
#ifdef DEBUG_QMLINTERFACE_H
    qDebug() << Q_FUNC_INFO;
#endif
    emit sgBtnSubsOnClicked();

}

void QmlInterface::onBtnSubsOffClicked()
{
#ifdef DEBUG_QMLINTERFACE_H
    qDebug() << Q_FUNC_INFO;
#endif
    emit sgBtnSubsOffClicked();
}
void QmlInterface::onBtnCheckDeviceInfoClicked()
{
#ifdef DEBUG_QMLINTERFACE_H
    qDebug() << Q_FUNC_INFO;
#endif
    emit sgBtnCheckDeviceInfoClicked();
}
void QmlInterface::onBtnLogShowClicked()
{
#ifdef DEBUG_QMLINTERFACE_H
    qDebug() << Q_FUNC_INFO;
#endif
    emit sgBtnLogShowClicked();
}
void QmlInterface::onBtnDbManagementClicked()
{
#ifdef DEBUG_QMLINTERFACE_H
    qDebug() << Q_FUNC_INFO;
#endif
    emit sgBtnDbManagementClicked();
}


QString QmlInterface::firebirdDBInstallLocation()
{
#ifdef DEBUG_QMLINTERFACE_H
    qDebug() << Q_FUNC_INFO;
#endif

    QString databaseInstalllocation = "";

    return databaseInstalllocation;
}

void QmlInterface::onBtnDBDownloadClicked()
{
#ifdef DEBUG_QMLINTERFACE_H
    qDebug() << Q_FUNC_INFO;
#endif

}

void QmlInterface::onBtnDbInitializeClicked()
{
#ifdef DEBUG_QMLINTERFACE_H
    qDebug() << Q_FUNC_INFO;
#endif

}

void QmlInterface::onBtnDbBackupClicked()
{
#ifdef DEBUG_QMLINTERFACE_H
    qDebug() << Q_FUNC_INFO;
#endif


}

void QmlInterface::onBtnDbRestoreClicked()
{
#ifdef DEBUG_QMLINTERFACE_H
    qDebug() << Q_FUNC_INFO;
#endif


    return;
}


void QmlInterface::setLoopback(QString danteName, bool on )
{
#ifdef DEBUG_QMLINTERFACE_H
    qDebug() << Q_FUNC_INFO;
#endif
    emit sgSetLoopback(danteName, on);
}

void QmlInterface::onBtnLoopbackOnClicked(int leftRow, int rightRow)
{
#ifdef DEBUG_QMLINTERFACE_H
    qDebug() << Q_FUNC_INFO;
#endif
    // left from rxzones right from registeredZones
    QModelIndex leftDanteNameIndex = m_qmlModelRxZones->index(leftRow, INDEX_QML_ZONES_DANTENAME);
    QModelIndex leftChannelNoIndex = m_qmlModelRxZones->index(leftRow, INDEX_QML_ZONES_CHANNELNO);

    QModelIndex rightDanteNameIndex = m_qmlModelRegisteredTxChannels->index(rightRow, INDEX_QML_ZONES_DANTENAME);
    QModelIndex rightChannelNoIndex = m_qmlModelRegisteredTxChannels->index(rightRow, INDEX_QML_ZONES_CHANNELNO);

    QString leftDanteName = m_qmlModelRxZones->data(leftDanteNameIndex, Qt::DisplayRole).toString();
    QString leftChannelNo = m_qmlModelRxZones->data(leftChannelNoIndex, Qt::DisplayRole).toString();

    QString rightDanteName = m_qmlModelRegisteredTxChannels->data(rightDanteNameIndex, Qt::DisplayRole).toString();
    QString rightChannelNo = m_qmlModelRegisteredTxChannels->data(rightChannelNoIndex, Qt::DisplayRole).toString();


    m_loopbackRxInfo = rightChannelNo + "@" + rightDanteName;
    m_loopbackTxInfo = leftChannelNo + "@" + leftDanteName;

    emit sgBtnLoopbackOperationOnClicked();

}
void QmlInterface::onBtnLoopbackOffClicked(int leftRow, int rightRow)
{
#ifdef DEBUG_QMLINTERFACE_H
    qDebug() << Q_FUNC_INFO;
#endif

    // left from rxzones right from registeredZones
    QModelIndex leftDanteNameIndex = m_qmlModelRxZones->index(leftRow, INDEX_QML_ZONES_DANTENAME);
    QModelIndex leftChannelNoIndex = m_qmlModelRxZones->index(leftRow, INDEX_QML_ZONES_CHANNELNO);

    QModelIndex rightDanteNameIndex = m_qmlModelRegisteredTxChannels->index(rightRow, INDEX_QML_ZONES_DANTENAME);
    QModelIndex rightChannelNoIndex = m_qmlModelRegisteredTxChannels->index(rightRow, INDEX_QML_ZONES_CHANNELNO);

    QString leftDanteName = m_qmlModelRxZones->data(leftDanteNameIndex, Qt::DisplayRole).toString();
    QString leftChannelNo = m_qmlModelRxZones->data(leftChannelNoIndex, Qt::DisplayRole).toString();

    QString rightDanteName = m_qmlModelRegisteredTxChannels->data(rightDanteNameIndex, Qt::DisplayRole).toString();
    QString rightChannelNo = m_qmlModelRegisteredTxChannels->data(rightChannelNoIndex, Qt::DisplayRole).toString();


    m_loopbackRxInfo = rightChannelNo + "@" + rightDanteName;
    m_loopbackTxInfo = leftChannelNo + "@" + leftDanteName;
    emit sgBtnLoopbackOperationOffClicked();
}

void QmlInterface::onBtnSelAllClicked()
{
#ifdef DEBUG_QMLINTERFACE_H
    qDebug() << Q_FUNC_INFO;
#endif

    QList <QStandardItem*> items;
    items = m_qmlModelAllZones->findItems("false", Qt::MatchExactly, INDEX_QML_ZONES_SELECTED );

    foreach( QStandardItem * item, items)
    {
        if( m_qmlModelAllZones->index(item->row(), INDEX_QML_ZONES_DEVICE_TYPE).data().toString() == "RX")
            item->setText("true");
    }

}

void QmlInterface::onBtnDeselAllClicked()
{
#ifdef DEBUG_QMLINTERFACE_H
    qDebug() << Q_FUNC_INFO;
#endif
    QList <QStandardItem*> items;
    items = m_qmlModelAllZones->findItems("true", Qt::MatchExactly, INDEX_QML_ZONES_SELECTED );

    foreach( QStandardItem * item, items)
    {
        if( m_qmlModelAllZones->index(item->row(), INDEX_QML_ZONES_DEVICE_TYPE).data().toString() == "RX")
            item->setText("false");
    }


    items = m_qmlModelGroups->findItems("true", Qt::MatchExactly, INDEX_QML_GROUPS_SELECTED );
    foreach( QStandardItem * item, items)
    {
        item->setText("false");
    }


}

void QmlInterface::onTxtDBNameEditingFinished(QString data)
{
#ifdef DEBUG_QMLINTERFACE_H
    qDebug() << Q_FUNC_INFO;
#endif


}

void QmlInterface::onTxtServerIPEditingFinished(QString data)
{
#ifdef DEBUG_QMLINTERFACE_H
    qDebug() << Q_FUNC_INFO;
#endif


}

void QmlInterface::onTxtUserNameEditingFinished(QString data)
{
#ifdef DEBUG_QMLINTERFACE_H
    qDebug() << Q_FUNC_INFO;
#endif

}

void QmlInterface::onTxtPasswordEditingFinished(QString data)
{
#ifdef DEBUG_QMLINTERFACE_H
    qDebug() << Q_FUNC_INFO;
#endif

}

QRegExpValidator* QmlInterface::ipValidator()
{
#ifdef DEBUG_QMLINTERFACE_H
    qDebug() << Q_FUNC_INFO;
#endif
    //ip4 RegExp
    QString Octet = "(?:[0-1]?[0-9]?[0-9]|2[0-4][0-9]|25[0-5])";
    QRegExpValidator* validator =
            new QRegExpValidator(
                QRegExp("^" + Octet + "\\." + Octet + "\\." + Octet + "\\." + Octet + "$"), this);

    return validator;
}



// (danteName / channeloccupation) -> QMap
QVariantMap QmlInterface::AllRxZonesInfo()
{
#ifdef DEBUG_DEVICECONTROLWND_H
    qDebug() << Q_FUNC_INFO;
#endif

    QVariantMap selectedRxZonesInfo;

    QList <int> rows;
    QList <QStandardItem*> items = m_qmlModelAllZones->findItems("RX", Qt::MatchExactly, INDEX_QML_ZONES_DEVICE_TYPE );


    foreach(QStandardItem* item, items)
    {
        rows << item->row();
    }

    foreach (int row , rows )
    {
        QString rxDanteName = m_qmlModelAllZones->item(row, INDEX_QML_ZONES_DANTENAME)->text();
        QString rxChannel = m_qmlModelAllZones->item(row, INDEX_QML_ZONES_CHANNELNO)->text();

        if( selectedRxZonesInfo.keys().indexOf(rxDanteName) != -1)
        {
            //�ߺ������Ͱ� �ִ� ���
            QString previousData  = selectedRxZonesInfo.take(rxDanteName).toString();
            selectedRxZonesInfo.insert(rxDanteName, previousData + "," + rxChannel);
        }
        else
        {
            selectedRxZonesInfo.insert(rxDanteName, rxChannel);
        }

    }

    qDebug() << Q_FUNC_INFO << selectedRxZonesInfo;
    return selectedRxZonesInfo;
}

// (danteName / channeloccupation) -> QMap
QVariantMap QmlInterface::selectedRxZonesInfo()
{
#ifdef DEBUG_DEVICECONTROLWND_H
    qDebug() << Q_FUNC_INFO;
#endif

    QVariantMap selectedRxZonesInfo;

    QList <int> rows;
    QList <QStandardItem*> items = m_qmlModelAllZones->findItems("true", Qt::MatchExactly, INDEX_QML_ZONES_SELECTED );


    foreach(QStandardItem* item, items)
    {
        rows << item->row();
    }

    foreach (int row , rows )
    {
        QStandardItem* item = m_qmlModelAllZones->item(row, INDEX_QML_ZONES_DEVICE_TYPE );
        if( item->text() == "RX" )
        {
            QString rxDanteName = m_qmlModelAllZones->item(row, INDEX_QML_ZONES_DANTENAME)->text();
            QString rxChannel = m_qmlModelAllZones->item(row, INDEX_QML_ZONES_CHANNELNO)->text();

            if( selectedRxZonesInfo.keys().indexOf(rxDanteName) != -1)
            {
                //�ߺ������Ͱ� �ִ� ���
                QString previousData  = selectedRxZonesInfo.take(rxDanteName).toString();
                selectedRxZonesInfo.insert(rxDanteName, previousData + "," + rxChannel);
            }
            else
            {
                selectedRxZonesInfo.insert(rxDanteName, rxChannel);
            }
        }
    }

    qDebug() << Q_FUNC_INFO << selectedRxZonesInfo;
    return selectedRxZonesInfo;
}
// (danteName @ channeloccupation)
QString QmlInterface::selectedTxZonesInfo()
{
#ifdef DEBUG_DEVICECONTROLWND_H
    qDebug() << Q_FUNC_INFO;
#endif

    QList <int> rows;
    QList <QStandardItem*> items = m_qmlModelRegisteredTxChannels->findItems("true", Qt::MatchExactly, INDEX_QML_ZONES_SELECTED );

    foreach(QStandardItem* item, items)
    {
        rows << item->row();
    }

    // tx �� ��� �����ʹ� �Ѱ��� ����
    foreach (int row , rows )
    {
        QString txDanteName = m_qmlModelRegisteredTxChannels->item(row, INDEX_QML_ZONES_DANTENAME)->text();
        QString txChannel = m_qmlModelRegisteredTxChannels->item(row, INDEX_QML_ZONES_CHANNELNO)->text();
        return txChannel + "@" + txDanteName;
    }

    return "";
}








