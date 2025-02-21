#ifndef DELRECTANGLE_H
#define DELRECTANGLE_H

#include <QQuickPaintedItem>

QT_FORWARD_DECLARE_CLASS(QQuickPen)
QT_FORWARD_DECLARE_CLASS(DelRectanglePrivate)

class DelPen: public QObject
{
    Q_OBJECT

    Q_PROPERTY(qreal width READ width WRITE setWidth NOTIFY widthChanged FINAL)
    Q_PROPERTY(QColor color READ color WRITE setColor NOTIFY colorChanged FINAL)

    QML_NAMED_ELEMENT(DelPen)

public:
    DelPen(QObject *parent = nullptr) : QObject{parent} { }

    qreal width() const { return m_width; }
    void setWidth(qreal width) {
        if (m_width != width) {
            m_width = width;
            emit widthChanged();
        }
    }

    QColor color() const { return m_color; }
    void setColor(const QColor &color) {
        if (m_color != color) {
            m_color = color;
            emit colorChanged();
        }
    }

    bool isValid() const {
        return m_width > 0 && m_color.isValid() && m_color.alpha() > 0;
    }

signals:
    void widthChanged();
    void colorChanged();

private:
    qreal m_width = 1;
    QColor m_color = Qt::transparent;
};

class DelRectangle: public QQuickPaintedItem
{
    Q_OBJECT

    Q_PROPERTY(qreal radius READ radius WRITE setRadius NOTIFY radiusChanged FINAL)
    Q_PROPERTY(qreal topLeftRadius READ topLeftRadius WRITE setTopLeftRadius NOTIFY topLeftRadiusChanged FINAL)
    Q_PROPERTY(qreal topRightRadius READ topRightRadius WRITE setTopRightRadius NOTIFY topRightRadiusChanged FINAL)
    Q_PROPERTY(qreal bottomLeftRadius READ bottomLeftRadius WRITE setBottomLeftRadius NOTIFY bottomLeftRadiusChanged FINAL)
    Q_PROPERTY(qreal bottomRightRadius READ bottomRightRadius WRITE setBottomRightRadius NOTIFY bottomRightRadiusChanged FINAL)

    Q_PROPERTY(QColor color READ color WRITE setColor NOTIFY colorChanged FINAL)
    Q_PROPERTY(DelPen* border READ border CONSTANT)

    QML_NAMED_ELEMENT(DelRectangle)

public:
    explicit DelRectangle(QQuickItem *parent = nullptr);
    ~DelRectangle();

    qreal radius() const;
    void setRadius(qreal radius);

    qreal topLeftRadius() const;
    void setTopLeftRadius(qreal radius);

    qreal topRightRadius() const;
    void setTopRightRadius(qreal radius);

    qreal bottomLeftRadius() const;
    void setBottomLeftRadius(qreal radius);

    qreal bottomRightRadius() const;
    void setBottomRightRadius(qreal radius);

    QColor color() const;
    void setColor(QColor color);

    DelPen *border();

    void paint(QPainter *painter) override;

signals:
    void radiusChanged();
    void topLeftRadiusChanged();
    void topRightRadiusChanged();
    void bottomLeftRadiusChanged();
    void bottomRightRadiusChanged();
    void colorChanged();

private:
    Q_DECLARE_PRIVATE(DelRectangle);
    QSharedPointer<DelRectanglePrivate> d_ptr;
};

#endif // DELRECTANGLE_H
