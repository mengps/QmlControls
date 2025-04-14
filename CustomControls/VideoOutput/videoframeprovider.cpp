#include "videoframeprovider.h"

#include <QFile>
#include <QFileInfo>
#include <QSharedPointer>
#include <QTimer>

class VideoFrameProviderPrivate
{
public:
    QAbstractVideoSurface *m_surface = nullptr;
    QVideoSurfaceFormat m_format;
    QString m_videoUrl;
    QSharedPointer<QVideoFrame> m_frame = nullptr;

    /**
     * 以下代码仅供示例使用
     * 实际上，此处应放你的视频源，它可以来自你自己的解码器
     */
    QVector<char> m_testData;
    QTimer *m_testTimer = nullptr;
};

VideoFrameProvider::VideoFrameProvider(QObject *parent)
    : QObject(parent)
{
    d = new VideoFrameProviderPrivate;

    int width = 1280;
    int height = 720;
    int size = width * height * 3 / 2;

    setFormat(width, height, QVideoFrame::Format_NV12);

    d->m_frame.reset(new QVideoFrame(size, QSize(width, height), width, QVideoFrame::Format_NV12));
    d->m_testTimer = new QTimer(this);

    //读入一张yuv图像
    QFile file(":/test.yuv");
    file.open(QIODevice::ReadOnly);
    QByteArray data = file.readAll();
    d->m_testData.resize(data.size());
    memcpy(d->m_testData.data(), data.constData(), size_t(data.size()));
    file.close();

    connect(d->m_testTimer, &QTimer::timeout, this, [=]{
        static int count = 0;

        //简单变化一下，模拟视频帧
        if (++count & 0x1) {
            for (auto &it : d->m_testData) {
                it *= 0.5;
            }
        } else {
            for (auto &it : d->m_testData) {
                it *= 2.0;
            }
        }

        if (d->m_frame->map(QAbstractVideoBuffer::WriteOnly)) {
            memcpy(d->m_frame->bits(), d->m_testData.data(), size_t(d->m_testData.size()));
            d->m_frame->unmap();
            emit newVideoFrame(*d->m_frame.get());
        };
    });
    connect(this, &VideoFrameProvider::newVideoFrame, this, &VideoFrameProvider::onNewVideoFrameReceived);

    d->m_testTimer->start(200);
}

VideoFrameProvider::~VideoFrameProvider()
{
    if (d) delete d;
}

QAbstractVideoSurface *VideoFrameProvider::videoSurface()
{
    return d->m_surface;
}

void VideoFrameProvider::setVideoSurface(QAbstractVideoSurface *surface)
{
    if (d->m_surface && d->m_surface != surface && d->m_surface->isActive()) {
        d->m_surface->stop();
    }

    d->m_surface = surface;

    if (d->m_surface && d->m_format.isValid()) {
        d->m_format = d->m_surface->nearestFormat(d->m_format);
        d->m_surface->start(d->m_format);
    }
}

QString VideoFrameProvider::videoUrl() const
{
    return d->m_videoUrl;
}

void VideoFrameProvider::setVideoUrl(const QString &url)
{
    if (d->m_videoUrl != url) {
        d->m_videoUrl = url;
        emit videoUrlChanged();
    }
}

void VideoFrameProvider::setFormat(int width, int heigth, QVideoFrame::PixelFormat pixFormat)
{
    QVideoSurfaceFormat format(QSize(width, heigth), pixFormat);
    d->m_format = format;

    if (d->m_surface) {
        if (d->m_surface->isActive()) {
            d->m_surface->stop();
        }
        d->m_format = d->m_surface->nearestFormat(format);
        d->m_surface->start(d->m_format);
    }
}

void VideoFrameProvider::onNewVideoFrameReceived(const QVideoFrame &frame)
{
    if (d->m_surface)
        d->m_surface->present(frame);
}
