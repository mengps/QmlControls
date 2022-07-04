#include "fpsitem.h"

#include <QQuickWindow>
#include <QTimer>

FpsItem::FpsItem(QQuickItem *parent)
    : QQuickItem(parent)
{
    QTimer *timer = new QTimer(this);
    connect(timer, &QTimer::timeout, this, [this]{ m_fps = m_frameCount; m_frameCount = 0; emit fpsChanged(); });
    connect(this, &QQuickItem::windowChanged, this, [this]{
        if (window())
            connect(window(), &QQuickWindow::afterRendering, this
                    , [this]{ m_frameCount++; }, Qt::DirectConnection);
    });
    timer->start(1000);
}

int FpsItem::fps() const
{
    return m_fps;
}
