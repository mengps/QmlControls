#ifndef MAGICFISH_H
#define MAGICFISH_H

#include <QQuickPaintedItem>

class QVariantAnimation;
class MagicFish : public QQuickPaintedItem
{
    Q_OBJECT

public:
    explicit MagicFish(QQuickPaintedItem *parent = nullptr);

    void setFishR(int value);
    void setCurrentAngle(qreal angle);
    void setFinAnimation(bool start);

    QPointF getHeadPos() const;

    qreal getFishR() const;
    qreal getAngle();
    QRectF geometry() const;

    void setWave(qreal value);

public slots:
    void resize();

protected:
    void paint(QPainter *painter);

private:
    QPointF calcPoint(const QPointF &pos, qreal length, qreal angle);
    void paintMyPoint(QPainter *painter, const QPointF pos);
    void paintMyFishFins(QPainter *painter, const QPointF &pos, bool is_left, qreal father_angle);
    void paintMyBody(QPainter *painter, const QPointF &pos, qreal seg_r, qreal MP, qreal father_angle);
    void paintMyBody2(QPainter *painter, const QPointF &pos, qreal seg_r, qreal MP, qreal father_angle);
    void paintMyTail(QPainter *painter, const QPointF &pos, qreal length, qreal max_w, qreal angle);

private:
    qreal m_bodyHeight;
    qreal m_fishRadius; // fish head r
    qreal m_finLen;
    int m_headAlpha;
    int m_bodyAlpha;
    int m_finAlpha;
    qreal m_mainAngle;
    int m_curValue;
    qreal m_wave;

    QVariantAnimation *m_animation;
    bool m_startFin;
    bool m_paintPoint;

    QPointF m_headPos;
};
#endif // MAGICFISH_H
