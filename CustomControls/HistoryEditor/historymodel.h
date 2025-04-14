#ifndef HISTORYMODEL_H
#define HISTORYMODEL_H

#include <QAbstractListModel>

class HistoryModel : public QAbstractListModel
{
    Q_OBJECT

public:
    HistoryModel();

    virtual int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    virtual int columnCount(const QModelIndex &parent = QModelIndex()) const override;

    virtual QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;

    Q_INVOKABLE void sortByKey(const QString &key);

private:
    QList<QString> m_data;
    QList<QString> m_historyData;
};

#endif // HISTORYMODEL_H
