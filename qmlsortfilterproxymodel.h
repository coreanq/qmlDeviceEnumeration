#ifndef QMLSORTFILTERPROXYMODEL_H
#define QMLSORTFILTERPROXYMODEL_H

#include <QSortFilterProxyModel>

class QmlSortFilterProxyModel : public QSortFilterProxyModel
{
    Q_OBJECT
public:
    explicit QmlSortFilterProxyModel(QObject *parent = 0);
    QHash<int, QByteArray> roleNames() const;
    QVariant data(const QModelIndex &index, int role) const;
    void applyRoles();
private:
   QHash<int, QByteArray> m_roles;
    
signals:
    
public slots:
    
};

#endif // QMLSORTFILTERPROXYMODEL_H
