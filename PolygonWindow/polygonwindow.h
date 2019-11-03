#ifndef POLYGONWINDOW_H
#define POLYGONWINDOW_H

#include <QQuickWindow>

class PolygonWindowPrivate;
class PolygonWindow : public QQuickWindow
{
    Q_OBJECT
    Q_PROPERTY(QUrl source READ source WRITE setSource NOTIFY sourceChanged)

public:
    explicit PolygonWindow(QWindow *parent = nullptr);
    ~PolygonWindow() override;

    QUrl source() const;
    void setSource(const QUrl &source);

signals:
    void sourceChanged();

protected:
    void mousePressEvent(QMouseEvent *event) override;
    void mouseReleaseEvent(QMouseEvent *event) override;
    void mouseMoveEvent(QMouseEvent *event) override;

private:
    void changeTexture();

    PolygonWindowPrivate *d;
};

#endif // POLYGONWINDOW_H
