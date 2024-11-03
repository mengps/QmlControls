#ifndef MAGICPOOL_H
#define MAGICPOOL_H

#include <QQuickPaintedItem>

QT_FORWARD_DECLARE_CLASS(MagicPoolPrivate);

class MagicPool : public QQuickPaintedItem
{
    Q_OBJECT

    Q_PROPERTY(bool moving READ moving CONSTANT)

public:
    explicit MagicPool(QQuickPaintedItem *parent = nullptr);
    ~MagicPool();

    bool moving() const;

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
    Q_DECLARE_PRIVATE(MagicPool);
    QScopedPointer<MagicPoolPrivate> d_ptr;
};

#endif // MAGICPOOL_H
