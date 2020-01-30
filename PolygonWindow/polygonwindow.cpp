#include "polygonwindow.h"

#include <QBitmap>
#include <QQuickItem>
#include <QQmlFile>
#include <QSGSimpleTextureNode>

class PolygonItem : public QQuickItem
{
public:
    PolygonItem(QQuickItem *parent = nullptr) : QQuickItem (parent) {
        setFlag(ItemHasContents);
    }

    void setTexture(QSGTexture *texture);

protected:
    virtual QSGNode *updatePaintNode(QSGNode *node, UpdatePaintNodeData *);

private:
    QScopedPointer<QSGTexture> m_texture;
};

void PolygonItem::setTexture(QSGTexture *texture)
{
    m_texture.reset(texture);
}

QSGNode* PolygonItem::updatePaintNode(QSGNode *node, UpdatePaintNodeData *)
{
    QSGSimpleTextureNode *n = static_cast<QSGSimpleTextureNode *>(node);
    if (n) {
        if (!m_texture.isNull()) {
            n->setTexture(m_texture.data());
            n->setFiltering(QSGTexture::Linear);
            n->setRect(boundingRect());
        }
    } else {
        n = new QSGSimpleTextureNode();
        if (!m_texture.isNull()) {
            n->setTexture(m_texture.data());
            n->setFiltering(QSGTexture::Linear);
            n->setRect(boundingRect());
        }
    }

    return n;
}

class PolygonWindowPrivate
{
public:
    QPoint m_startPos;
    QPoint m_oldPos;
    QUrl m_source;
    QPixmap m_background;
    QScopedPointer<PolygonItem> m_centerItem;
};

PolygonWindow::PolygonWindow(QWindow *parent)
    : QQuickWindow (parent)
{
    d = new PolygonWindowPrivate;
    setOpacity(0.8);
    setColor(Qt::transparent);
    setFlags(flags() | Qt::Window | Qt::FramelessWindowHint);

    connect(this, &QQuickWindow::widthChanged, this, [this](int) {
        changeTexture();
    });
    connect(this, &QQuickWindow::heightChanged, this, [this](int) {
        changeTexture();
    });
    connect(this, &QQuickWindow::sceneGraphInitialized, this, [this]() {
        d->m_centerItem.reset(new PolygonItem(contentItem()));
        changeTexture();
    });
}

PolygonWindow::~PolygonWindow()
{
    delete d;
}

QUrl PolygonWindow::source() const
{
    return d->m_source;
}

void PolygonWindow::setSource(const QUrl &source)
{
    if (source != d->m_source) {
        d->m_source = source;
        d->m_background = QQmlFile::urlToLocalFileOrQrc(source);
        changeTexture();
        emit sourceChanged();
    }
}

void PolygonWindow::mousePressEvent(QMouseEvent *event)
{
    d->m_startPos = event->globalPos();
    d->m_oldPos = position();
    event->ignore();

    QQuickWindow::mousePressEvent(event);
}

void PolygonWindow::mouseReleaseEvent(QMouseEvent *event)
{
    d->m_oldPos = position();

    QQuickWindow::mouseReleaseEvent(event);
}

void PolygonWindow::mouseMoveEvent(QMouseEvent *event)
{
    if (event->buttons() & Qt::LeftButton) {
        setPosition(d->m_oldPos - d->m_startPos + event->globalPos());
    }

    QQuickWindow::mouseMoveEvent(event);
}

void PolygonWindow::changeTexture()
{
    auto texture = d->m_background.scaled(size(), Qt::IgnoreAspectRatio, Qt::SmoothTransformation);
    if (!texture.isNull()) {
        d->m_background = texture;
        setMask(QRegion(d->m_background.mask()));
        if (d->m_centerItem) {
            d->m_centerItem->setSize(size());
            d->m_centerItem->setTexture(createTextureFromImage(d->m_background.toImage(), TextureHasAlphaChannel));
        }
    }
    update();
}
