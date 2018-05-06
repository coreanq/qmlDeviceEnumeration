#include "qmlsortfilterproxymodel.h"
#include <QDebug>

QmlSortFilterProxyModel::QmlSortFilterProxyModel(QObject *parent) :
    QSortFilterProxyModel(parent)
{
}

void QmlSortFilterProxyModel::applyRoles()
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

QHash<int, QByteArray> QmlSortFilterProxyModel::roleNames() const
{
    return m_roles;
}

QVariant QmlSortFilterProxyModel::data(const QModelIndex &index, int role) const
{
    QVariant value;
    if(role < Qt::UserRole)
    {
        value = QSortFilterProxyModel::data(index, role);
    }
    else {
        int columnIdx = role - Qt::UserRole - 1;
        QModelIndex modelIndex = this->index(index.row(), columnIdx);
        value = QSortFilterProxyModel::data(modelIndex, Qt::DisplayRole);
    }
    return value;
}

