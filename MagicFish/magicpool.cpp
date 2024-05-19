#include "magicpool.h"
#include <QtMath>
#include <QTimer>
#include <QPainter>

MagicPool::MagicPool(QQuickPaintedItem *parent)
    : QQuickPaintedItem(parent),
      m_moving(false),
      m_startCircle(false),
      m_circleRadius(4),
      m_circleAlpha(150),
      m_moveStep(0.0)
{
    m_circleTimer = new QTimer(this);
    m_circleTimer->setInterval(20);
    connect(m_circleTimer, &QTimer::timeout, this, &MagicPool::updateValue);

    m_moveTimer = new QTimer(this);
    m_moveTimer->setInterval(20);
    connect(m_moveTimer, &QTimer::timeout, this, &MagicPool::updateMove);
    m_fish = new MagicFish(this);
    m_fish->setSize(QSize(100, 100));
}

void MagicPool::updateValue()
{
    m_circleRadius += 2;
    m_circleAlpha -= 3;

    if (m_circleAlpha <= 0) {
        m_circleAlpha = 150;
        m_circleRadius = 4;
        m_startCircle = false;
        m_circleTimer->stop();
    }
    update();
}

void MagicPool::updateMove()
{
    qreal tmp = 0.00;
    if (m_moveStep >= 0.85) {
        tmp = qSin(qDegreesToRadians(m_moveStep * 180)) * 0.02;
        m_fish->setFinAnimation(false);
        m_fish->setWave(1.0);
    } else {
        tmp = 0.012 + qCos(qDegreesToRadians(m_moveStep * 90)) * 0.02;
        //m_fish->setWave(1.0 / (m_moveStep + 0.1));
    }
    m_moveStep += tmp;
    if (m_moveStep >= 1.0 || (1 - m_moveStep) <= 0.003) {
        m_moving = false;
        m_moveStep = 0.0;
        m_path = QPainterPath();
        m_moveTimer->stop();
    } else {
        QPointF p = m_path.pointAtPercent(m_moveStep);
        m_fish->setCurrentAngle(m_path.angleAtPercent(m_moveStep));
        m_fish->setPosition(QPointF(p.x(), p.y()));
        update();
    }
}

void MagicPool::moveFish(qreal x, qreal y, bool hasCircle)
{
    m_moving = true;
    m_startCircle = hasCircle;
    m_pos = QPointF(x, y);
    m_circleRadius = 4;
    m_circleAlpha = 150;
    m_moveStep = 0.0;

    QPointF m_fish_middle = m_fish->geometry().center();
    QPointF m_fish_head = m_fish->geometry().topLeft() + m_fish->getHeadPos();
    qreal angle = calcIncludedAngle(m_fish_middle, m_fish_head, m_pos);
    qreal delta = calcIncludedAngle(m_fish_middle, m_fish_middle + QPointF(1, 0), m_fish_head);
    QPointF c = calcPoint(m_fish_middle, 17 * m_fish->getFishR(), angle / 2 + delta);
    QPointF p(m_fish->width() / 2, m_fish->height() / 2);
    m_path = QPainterPath();
    m_path.moveTo(m_fish->geometry().topLeft());
    m_path.cubicTo(m_fish_head - p, c - p, m_pos - p);

    if (hasCircle) m_circleTimer->start();
    m_moveTimer->start();
    m_fish->setFinAnimation(true);
    m_fish->setWave(2.5);
}

void MagicPool::paint(QPainter *painter)
{
    if (m_startCircle) {
        painter->setRenderHint(QPainter::Antialiasing);
        painter->setPen(QPen(QColor(20, 203, 232, m_circleAlpha), 3));
        painter->drawEllipse(m_pos, m_circleRadius, m_circleRadius);
        if (m_circleRadius >= 15) {
            painter->drawEllipse(m_pos, m_circleRadius - 15, m_circleRadius - 15);
            if (m_circleRadius >= 30) {
                painter->drawEllipse(m_pos, m_circleRadius - 30, m_circleRadius - 30);
                if (m_circleRadius >= 45)
                    painter->drawEllipse(m_pos, m_circleRadius - 45, m_circleRadius - 45);
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

