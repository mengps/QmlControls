#ifndef MAGICFISH_H
#define MAGICFISH_H

#include <QQuickPaintedItem>

QT_FORWARD_DECLARE_CLASS(MagicFishPrivate);
QT_FORWARD_DECLARE_CLASS(QVariantAnimation);

class MagicFish : public QQuickPaintedItem
{
    Q_OBJECT

public:
    explicit MagicFish(QQuickPaintedItem *parent = nullptr);
    ~MagicFish();

    void setFishR(int value);
    qreal getFishR() const;

    qreal getAngle();
    void setCurrentAngle(qreal angle);

    void setFinAnimation(bool start);

    void setWave(qreal value);

    QPointF getHeadPos() const;

    QRectF geometry() const;

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
    Q_DECLARE_PRIVATE(MagicFish);
    QScopedPointer<MagicFishPrivate> d_ptr;
};
#endif // MAGICFISH_H
