#ifndef QMLSTANDARDITEMMODEL_H
#define QMLSTANDARDITEMMODEL_H

#include <QStandardItemModel>

class QmlStandardItemModel : public QStandardItemModel
{
    Q_OBJECT
public:
    explicit QmlStandardItemModel(QObject *parent = 0);
    QVariant data(const QModelIndex &index, int role) const;
    void applyRoles();

    QHash<int, QByteArray> roleNames() const;

private:
   QHash<int, QByteArray> m_roles;

signals:
public slots:
    
};

#endif // QMLSTANDARDITEMMODEL_H
