#include "historymodel.h"
#include <QMultiMap>
#include <QRandomGenerator>

HistoryModel::HistoryModel()
{
    /**
     * @note historyData <QList>
     * 用于存储历史记录。
     * 可自由填充，我这里直接手动填充了。
     */
    for (int i = 0; i < 20; ++i) {
        QString randStr;
        for (int j = 0; j < 10; ++j) {
            randStr += QString::number(QRandomGenerator::global()->generate() % 10);
        }
        m_historyData.push_back("测试" + randStr);
    }

    m_data = m_historyData;
}

int HistoryModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    return m_data.count();
}

int HistoryModel::columnCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    return 1;
}

QVariant HistoryModel::data(const QModelIndex &index, int role) const
{
    if (index.row() < 0 || index.row() >= m_data.count())
        return QVariant();

    switch (role) {
        case Qt::DisplayRole:
            return m_data.at(index.row());

    default:
        break;
    }

    return QVariant();
}

void HistoryModel::sortByKey(const QString &key)
{
    if (key.isEmpty()) {
        beginResetModel();
        m_data = m_historyData;
        endResetModel();
    } else {
        QMultiMap<int, QString> temp;
        for (const auto &str : qAsConst(m_historyData)) {
            int ret = str.indexOf(key);
            if (ret == -1) continue;
            else temp.insert(ret, str);
        }

        beginResetModel();
        m_data.clear();
        if (!temp.isEmpty()) {
            //也可 for range-based
            for (auto it = temp.begin(); it != temp.end(); it++) {
                m_data.push_back(it.value());
            }
        }
        endResetModel();
    }
}
