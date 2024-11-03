#include "magicfish.h"
#include <QtMath>
#include <QPainter>
#include <QPainterPath>
#include <QVariantAnimation>

class MagicFishPrivate
{
public:
    qreal m_bodyHeight { 30 * 3.2 };
    qreal m_fishRadius { 30 }; // fish head r
    qreal m_finLen { 30 * 1.3 };
    int m_headAlpha { 200 };
    int m_bodyAlpha { 225 };
    int m_finAlpha { 120 };
    qreal m_mainAngle { 0.0 };
    int m_curValue { 0 };
    qreal m_wave { 1.0 };
    bool m_startFin { false };
    bool m_paintPoint { false };
    QPointF m_headPos;
    QVariantAnimation *m_animation = nullptr;
};

MagicFish::MagicFish(QQuickPaintedItem *parent)
    : QQuickPaintedItem(parent)
    , d_ptr(new MagicFishPrivate)
{
    Q_D(MagicFish);

    d->m_animation = new QVariantAnimation(this);
    d->m_animation->setDuration(180 * 1000);
    d->m_animation->setStartValue(0);
    d->m_animation->setEndValue(54000);
    d->m_animation->setLoopCount(-1);
    connect(d->m_animation, &QVariantAnimation::valueChanged, this, [this](const QVariant &value) {
        Q_D(MagicFish);
        d->m_curValue = value.toInt();
        update();
    });

    connect(this, &QQuickItem::widthChanged, this, &MagicFish::resize);
    connect(this, &QQuickItem::heightChanged, this, &MagicFish::resize);

    d->m_animation->start();
}

MagicFish::~MagicFish()
{

}

void MagicFish::paint(QPainter *painter)
{
    Q_D(MagicFish);

    painter->setRenderHint(QPainter::Antialiasing);
    QPointF middle_pos = QPointF(width() / 2, height() / 2);
    d->m_headPos = calcPoint(middle_pos, d->m_bodyHeight / 2.0, d->m_mainAngle);
    paintMyPoint(painter, d->m_headPos);
    paintMyPoint(painter, middle_pos);
    painter->setPen(Qt::NoPen);
    painter->setBrush(QBrush(QColor(20, 203, 232, 50)));
    painter->setBrush(QBrush(QColor(244, 92, 71, d->m_headAlpha)));
    painter->drawEllipse(d->m_headPos, d->m_fishRadius, d->m_fishRadius);

    qreal angle = d->m_mainAngle + qSin(qDegreesToRadians(d->m_curValue * 1.2 * d->m_wave)) * 2;
    QPointF end_pos = calcPoint(d->m_headPos, d->m_bodyHeight, angle - 180);
    QPointF pos1 = calcPoint(d->m_headPos, d->m_fishRadius, angle - 80);
    QPointF pos2 = calcPoint(end_pos, d->m_fishRadius * 0.7, angle - 90);
    QPointF pos3 = calcPoint(end_pos, d->m_fishRadius * 0.7, angle + 90);
    QPointF pos4 = calcPoint(d->m_headPos, d->m_fishRadius, angle + 80);

    QPointF central_left = calcPoint(d->m_headPos, d->m_bodyHeight * 0.56, angle - 130);
    QPointF central_right = calcPoint(d->m_headPos, d->m_bodyHeight * 0.56, angle + 130);
    QPainterPath path;
    path.moveTo(pos1);
    path.quadTo(central_left, pos2);
    path.lineTo(pos3);
    path.quadTo(central_right, pos4);
    path.lineTo(pos1);

    painter->setBrush(QBrush(QColor(244, 92, 71, d->m_bodyAlpha)));
    painter->drawPath(path);

    paintMyBody(painter, end_pos, d->m_fishRadius * 0.7, 0.6, angle);
    QPointF left_fin_pos = calcPoint(d->m_headPos, d->m_fishRadius * 0.9, angle + 110);
    paintMyFishFins(painter, left_fin_pos, true, angle);
    QPointF right_fin_pos = calcPoint(d->m_headPos, d->m_fishRadius * 0.9, angle - 110);
    paintMyFishFins(painter, right_fin_pos, false, angle);
}

void MagicFish::resize()
{
    Q_D(MagicFish);

    d->m_fishRadius = qMin(width(), height()) / 10.0;
    d->m_finLen = d->m_fishRadius * 1.3;
    d->m_bodyHeight = d->m_fishRadius * 3.2;
}

QPointF MagicFish::calcPoint(const QPointF &pos, qreal length, qreal angle)
{
    Q_D(MagicFish);

    qreal delta_x = qCos(qDegreesToRadians(angle)) * length;
    qreal delta_y = qSin(qDegreesToRadians(angle - 180)) * length;
    return QPointF(pos + QPointF(delta_x, delta_y));
}

void MagicFish::paintMyPoint(QPainter *painter, const QPointF pos)
{
    Q_D(MagicFish);

    if (d->m_paintPoint) {
        painter->save();
        painter->setPen(QPen(Qt::black, 3));
        painter->setBrush(QBrush(Qt::black));
        painter->drawPoint(pos);
        painter->restore();
    }
}

void MagicFish::paintMyFishFins(QPainter *painter, const QPointF &pos, bool is_left, qreal father_angle)
{
    Q_D(MagicFish);

    qreal contral_angle = 115;
    qreal fin_angle = d->m_startFin ? qSin(qDegreesToRadians(d->m_curValue * 16.1 * d->m_wave)) * 12.0 : 2;
    QPainterPath path;
    path.moveTo(pos);
    QPointF end_pos = calcPoint(pos, d->m_finLen, is_left ? father_angle + fin_angle + 180 :
                                                           father_angle - fin_angle - 180);
    QPointF control_pos = calcPoint(pos, d->m_finLen * 1.8, is_left ?
                                    father_angle + contral_angle + fin_angle :
                                    father_angle - contral_angle - fin_angle);

    path.quadTo(control_pos, end_pos);
    path.lineTo(pos);

    painter->save();
    painter->setBrush(QBrush(QColor(244, 92, 71, d->m_finAlpha)));
    painter->drawPath(path);
    painter->restore();
}

void MagicFish::paintMyBody(QPainter *painter, const QPointF &pos, qreal seg_r, qreal MP, qreal father_angle)
{
    Q_D(MagicFish);

    qreal angle = father_angle + qCos(qDegreesToRadians(d->m_curValue * 1.5 * d->m_wave)) * 15;
    qreal length = seg_r * (MP + 1);
    QPointF end_pos = calcPoint(pos, length, angle - 180);

    QPointF pos1 = calcPoint(pos, seg_r, angle - 90);
    QPointF pos2 = calcPoint(end_pos, seg_r * MP, angle - 90);
    QPointF pos3 = calcPoint(end_pos, seg_r * MP, angle + 90);
    QPointF pos4 = calcPoint(pos, seg_r, angle + 90);

    painter->save();
    painter->setBrush(QBrush(QColor(244, 92, 71, d->m_headAlpha)));
    painter->drawEllipse(pos, seg_r, seg_r);
    painter->drawEllipse(end_pos, seg_r * MP, seg_r * MP);

    QPainterPath path;
    path.moveTo(pos1);
    path.lineTo(pos2);
    path.lineTo(pos3);
    path.lineTo(pos4);
    painter->drawPath(path);
    painter->restore();
    paintMyBody2(painter, end_pos, seg_r * 0.6, 0.4, angle);
}

void MagicFish::paintMyBody2(QPainter *painter, const QPointF &pos, qreal seg_r, qreal MP, qreal father_angle)
{
    Q_D(MagicFish);

    qreal angle = father_angle + qSin(qDegreesToRadians(d->m_curValue * 1.5 * d->m_wave)) * 35;
    qreal length = seg_r * (MP + 2.7);
    QPointF end_pos = calcPoint(pos, length, angle - 180);

    QPointF pos1 = calcPoint(pos, seg_r, angle - 90);
    QPointF pos2 = calcPoint(end_pos, seg_r * MP, angle - 90);
    QPointF pos3 = calcPoint(end_pos, seg_r * MP, angle + 90);
    QPointF pos4 = calcPoint(pos, seg_r, angle + 90);
    paintMyTail(painter, pos, length, seg_r, angle);

    painter->save();
    painter->setBrush(QBrush(QColor(244, 92, 71, d->m_headAlpha)));
    painter->drawEllipse(end_pos, seg_r * MP, seg_r * MP);

    QPainterPath path;
    path.moveTo(pos1);
    path.lineTo(pos2);
    path.lineTo(pos3);
    path.lineTo(pos4);
    painter->drawPath(path);
    painter->restore();
}

void MagicFish::paintMyTail(QPainter *painter, const QPointF &pos, qreal length, qreal max_w, qreal angle)
{
    Q_D(MagicFish);

    qreal w = qAbs(qSin(qDegreesToRadians(d->m_curValue * 1.7 * d->m_wave)) * max_w + d->m_fishRadius / 5.0 * 3.0);
    QPointF end_point1 = calcPoint(pos, length, angle - 180);
    QPointF end_point2 = calcPoint(pos, length - 10, angle - 180);

    QPointF pos1 = calcPoint(end_point1, w, angle - 90);
    QPointF pos2 = calcPoint(end_point1, w, angle + 90);
    QPointF pos3 = calcPoint(end_point2, w - d->m_fishRadius / 1.5, angle - 90);
    QPointF pos4 = calcPoint(end_point2, w - d->m_fishRadius / 1.5, angle + 90);

    QPainterPath path;
    path.moveTo(pos);
    path.lineTo(pos3);
    path.lineTo(pos4);
    path.lineTo(pos);
    painter->save();
    painter->setBrush(QBrush(QColor(244, 92, 71, d->m_headAlpha)));
    painter->drawPath(path);

    path.closeSubpath();
    path.moveTo(pos);
    path.lineTo(pos1);
    path.lineTo(pos2);
    path.lineTo(pos);
    painter->drawPath(path);
    painter->restore();
}

void MagicFish::setWave(qreal value)
{
    Q_D(MagicFish);

    d->m_wave = value;
}

qreal MagicFish::getFishR() const
{
    Q_D(const MagicFish);

    return d->m_fishRadius;
}

qreal MagicFish::getAngle()
{
    Q_D(MagicFish);

    return d->m_mainAngle;
}

QRectF MagicFish::geometry() const
{
    Q_D(const MagicFish);

    return QRectF(x(), y(), width(), height());
}

QPointF MagicFish::getHeadPos() const
{
    Q_D(const MagicFish);

    return d->m_headPos;
}

void MagicFish::setCurrentAngle(qreal angle)
{
    Q_D(MagicFish);

    d->m_mainAngle = angle;

    update();
}

void MagicFish::setFinAnimation(bool start)
{
    Q_D(MagicFish);

    d->m_startFin = start;
}

void MagicFish::setFishR(int value)
{
    Q_D(MagicFish);

    d->m_fishRadius = value;
    d->m_finLen = value * 1.3;
    d->m_bodyHeight = value * 3.2;

    update();
}
