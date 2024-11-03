#include "magicpool.h"
#include "magicfish.h"

#include <QtMath>
#include <QTimer>
#include <QPainter>
#include <QPainterPath>

class MagicPoolPrivate
{
public:
    bool m_moving { false };
    bool m_startCircle { false };
    int m_circleRadius { 4 };
    int m_circleAlpha { 150 };
    QPointF m_pos;
    QPainterPath m_path;
    qreal m_moveStep { 0.0 };
    MagicFish *m_fish;
    QTimer *m_circleTimer;
    QTimer *m_moveTimer;
};

MagicPool::MagicPool(QQuickPaintedItem *parent)
    : QQuickPaintedItem(parent)
    , d_ptr(new MagicPoolPrivate)
{
    Q_D(MagicPool);

    d->m_circleTimer = new QTimer(this);
    d->m_circleTimer->setInterval(20);
    connect(d->m_circleTimer, &QTimer::timeout, this, &MagicPool::updateValue);

    d->m_moveTimer = new QTimer(this);
    d->m_moveTimer->setInterval(20);
    connect(d->m_moveTimer, &QTimer::timeout, this, &MagicPool::updateMove);
    d->m_fish = new MagicFish(this);
    d->m_fish->setSize(QSize(100, 100));
}

MagicPool::~MagicPool()
{

}

bool MagicPool::moving() const
{
    Q_D(const MagicPool);

    return d->m_moving;
}

void MagicPool::updateValue()
{
    Q_D(MagicPool);

    d->m_circleRadius += 2;
    d->m_circleAlpha -= 3;

    if (d->m_circleAlpha <= 0) {
        d->m_circleAlpha = 150;
        d->m_circleRadius = 4;
        d->m_startCircle = false;
        d->m_circleTimer->stop();
    }
    update();
}

void MagicPool::updateMove()
{
    Q_D(MagicPool);

    qreal tmp = 0.00;
    if (d->m_moveStep >= 0.85) {
        tmp = qSin(qDegreesToRadians(d->m_moveStep * 180)) * 0.02;
        d->m_fish->setFinAnimation(false);
        d->m_fish->setWave(1.0);
    } else {
        tmp = 0.012 + qCos(qDegreesToRadians(d->m_moveStep * 90)) * 0.02;
        //d->m_fish->setWave(1.0 / (d->m_moveStep + 0.1));
    }
    d->m_moveStep += tmp;
    if (d->m_moveStep >= 1.0 || (1 - d->m_moveStep) <= 0.003) {
        d->m_moving = false;
        d->m_moveStep = 0.0;
        d->m_path = QPainterPath();
        d->m_moveTimer->stop();
    } else {
        QPointF p = d->m_path.pointAtPercent(d->m_moveStep);
        d->m_fish->setCurrentAngle(d->m_path.angleAtPercent(d->m_moveStep));
        d->m_fish->setPosition(QPointF(p.x(), p.y()));
        update();
    }
}

void MagicPool::moveFish(qreal x, qreal y, bool hasCircle)
{
    Q_D(MagicPool);

    d->m_moving = true;
    d->m_startCircle = hasCircle;
    d->m_pos = QPointF(x, y);
    d->m_circleRadius = 4;
    d->m_circleAlpha = 150;
    d->m_moveStep = 0.0;

    QPointF fish_middle = d->m_fish->geometry().center();
    QPointF fish_head = d->m_fish->geometry().topLeft() + d->m_fish->getHeadPos();
    qreal angle = calcIncludedAngle(fish_middle, fish_head, d->m_pos);
    qreal delta = calcIncludedAngle(fish_middle, fish_middle + QPointF(1, 0), fish_head);
    QPointF c = calcPoint(fish_middle, 17 * d->m_fish->getFishR(), angle / 2 + delta);
    QPointF p(d->m_fish->width() / 2, d->m_fish->height() / 2);
    d->m_path = QPainterPath();
    d->m_path.moveTo(d->m_fish->geometry().topLeft());
    d->m_path.cubicTo(fish_head - p, c - p, d->m_pos - p);

    if (hasCircle) d->m_circleTimer->start();
    d->m_moveTimer->start();
    d->m_fish->setFinAnimation(true);
    d->m_fish->setWave(2.5);
}

void MagicPool::paint(QPainter *painter)
{
    Q_D(MagicPool);

    if (d->m_startCircle) {
        painter->setRenderHint(QPainter::Antialiasing);
        painter->setPen(QPen(QColor(20, 203, 232, d->m_circleAlpha), 3));
        painter->drawEllipse(d->m_pos, d->m_circleRadius, d->m_circleRadius);
        if (d->m_circleRadius >= 15) {
            painter->drawEllipse(d->m_pos, d->m_circleRadius - 15, d->m_circleRadius - 15);
            if (d->m_circleRadius >= 30) {
                painter->drawEllipse(d->m_pos, d->m_circleRadius - 30, d->m_circleRadius - 30);
                if (d->m_circleRadius >= 45)
                    painter->drawEllipse(d->m_pos, d->m_circleRadius - 45, d->m_circleRadius - 45);
            }
        }
    }
}

qreal MagicPool::calcIncludedAngle(const QPointF &center, const QPointF &head, const QPointF &touch)
{
    qreal abc = (head.x() - center.x()) * (touch.x() - center.x()) +
                (head.y() - center.y()) * (touch.y() - center.y());
    qreal cos_abc = (abc) / qSqrt((head.x() - center.x()) * (head.x() - center.x()) + (head.y() - center.y()) * (head.y() - center.y())) /
                          qSqrt((touch.x() - center.x()) * (touch.x() - center.x()) + (touch.y() - center.y()) * (touch.y() - center.y()));
    qreal tmp_angle = qRadiansToDegrees(qAcos(cos_abc));
    qreal direction = (center.x() - touch.x()) * (head.y() - touch.y()) -
                      (center.y() - touch.y()) * (head.x() - touch.x());
    if (direction == 0) {
        if (abc >= 0) {
            return 0;
        } else {
            return 180;
        }
    } else {
        if (direction > 0) {
            return -tmp_angle;
        } else {
            return tmp_angle;
        }
    }
}

QPointF MagicPool::calcPoint(const QPointF &pos, qreal length, qreal angle)
{
    qreal delta_x = qCos(qDegreesToRadians(angle)) * length;
    qreal delta_y = qSin(qDegreesToRadians(angle - 180)) * length;
    return QPointF(pos + QPointF(delta_x, delta_y));
}

qreal MagicPool::getLength(const QPointF &pos1, const QPointF &pos2)
{
    return qSqrt((pos1.x() - pos2.x()) * (pos1.x() - pos2.x())
               + (pos1.y() - pos2.y()) * (pos1.y() - pos2.y()));
}


