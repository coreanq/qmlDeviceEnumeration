#include "qmlstandarditemmodel.h"
#include <QDebug>

QmlStandardItemModel::QmlStandardItemModel(QObject *parent) :
    QStandardItemModel(parent)
{
}
void QmlStandardItemModel::applyRoles()
{
    m_roles.clear();

    for (int i = 0; i < this->columnCount(); i++)
    {
        QString role=this->headerData(i, Qt::Horizontal).toString();
        m_roles[Qt::UserRole + i + 1] = QVariant(role).toByteArray();
//        qDebug()<< Q_FUNC_INFO << this->headerData(i, Qt::Horizontal);
    }

#if (QT_VERSION < QT_VERSION_CHECK(5, 0, 0))
    setRoleNames(m_roles);
#endif

}

QHash<int, QByteArray> QmlStandardItemModel::roleNames() const
{
//    qDebug() << Q_FUNC_INFO << m_roles;
    return m_roles;

}

QVariant QmlStandardItemModel::data(const QModelIndex &index, int role) const
{
    QVariant value;
    if(role < Qt::UserRole)
    {
        value = QStandardItemModel::data(index, role);
    }
    else {
        int columnIdx = role - Qt::UserRole - 1;
        QModelIndex modelIndex = this->index(index.row(), columnIdx);
        value = QStandardItemModel::data(modelIndex, Qt::DisplayRole);
    }
    return value;
}
