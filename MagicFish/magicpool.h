#ifndef MAGICPOOL_H
#define MAGICPOOL_H

#include "magicfish.h"
#include <QPainterPath>
#include <QQuickPaintedItem>

class MagicPool : public QQuickPaintedItem
{
    Q_OBJECT

    Q_PROPERTY(bool moving READ moving CONSTANT)

public:
    MagicPool(QQuickPaintedItem *parent = nullptr);

    bool moving() const { return m_moving; }

public slots:
    void updateValue();
    void updateMove();
    void moveFish(qreal x, qreal y, bool hasCircle);

protected:
    void paint(QPainter *painter);

private:
    qreal calcIncludedAngle(const QPointF &center, const QPointF &head, const QPointF &touch);
    QPointF calcPoint(const QPointF &pos, qreal length, qreal angle);
    qreal getLength(const QPointF &pos1, const QPointF &pos2);

private:
    bool m_moving;
    bool m_startCircle;
    QTimer *m_circleTimer;
    QTimer *m_moveTimer;
    int m_circleRadius;
    int m_circleAlpha;
    QPointF m_pos;

    MagicFish *m_fish;

    QPainterPath m_path;
    qreal m_moveStep;
};

#endif // MAGICPOOL_H
