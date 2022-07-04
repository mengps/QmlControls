#ifndef FPSITEM_H
#define FPSITEM_H

#include <QQuickItem>

class FpsItem : public QQuickItem
{
    Q_OBJECT

    Q_PROPERTY(int fps READ fps NOTIFY fpsChanged)

public:
    FpsItem(QQuickItem *parent = nullptr);

    int fps() const;

signals:
    void fpsChanged();

private:
    int m_fps = 0;
    int m_frameCount = 0;
};

#endif // FPSITEM_H
