#include "asynchasher.h"

#include <QBuffer>
#include <QDebug>
#include <QFile>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QRunnable>
#include <QThreadPool>
#include <QtConcurrent>

class AsyncRunnable : public QObject, public QRunnable
{
    Q_OBJECT

public:
    AsyncRunnable(QIODevice *device, QCryptographicHash::Algorithm algorithm)
        : QObject{nullptr}, m_device(device), m_algorithm(algorithm)
    {
        setAutoDelete(false);
    }

    void cancel() {
        m_stop = true;
    }

signals:
    void progress(qint64 processed, qint64 total);
    void finished(const QString &result);

protected:
    virtual void run() {
        if (m_device) {
            static constexpr qint64 chunkSize = 4 * 1024 * 1024;
            QCryptographicHash hash(m_algorithm);
            qint64 processed = 0;
            qint64 total = m_device->size();
            while (!m_device->atEnd()) {
                if (m_stop) {
                    m_device->deleteLater();
                    return;
                }
                auto readData = m_device->read(std::min(chunkSize, total));
                hash.addData(readData);
                processed += readData.size();
                emit progress(processed, total);
            }
            emit finished(hash.result().toHex().toUpper());
            m_device->deleteLater();
        }
    }

    std::atomic_bool m_stop = { false };
    QIODevice *m_device = nullptr;
    QCryptographicHash::Algorithm m_algorithm;
};

class AsyncHasherPrivate
{
public:
    void cleanupRunnable()
    {
        if (m_runnable) {
            m_runnable->cancel();
            m_runnable->disconnect();
            m_runnable->deleteLater();
            m_runnable = nullptr;
        }
    }

    QCryptographicHash::Algorithm m_algorithm = QCryptographicHash::Md5;
    bool m_asynchronous = true;
    QString m_hashValue;
    QUrl m_source;
    QString m_sourceText;
    QByteArray m_sourceData;
    QObject *m_sourceObject = nullptr;
    QNetworkReply *m_reply = nullptr;
    QNetworkAccessManager m_manager;
    AsyncRunnable *m_runnable = nullptr;
};

AsyncHasher::AsyncHasher(QObject *parent)
    : QObject{parent}
    , d_ptr(new AsyncHasherPrivate)
{

}

AsyncHasher::~AsyncHasher()
{
    Q_D(AsyncHasher);

    d->cleanupRunnable();
}

QCryptographicHash::Algorithm AsyncHasher::algorithm()
{
    Q_D(AsyncHasher);

    return d->m_algorithm;
}

void AsyncHasher::setAlgorithm(QCryptographicHash::Algorithm algorithm)
{
    Q_D(AsyncHasher);

    if (d->m_algorithm != algorithm) {
        d->m_algorithm = algorithm;
        emit algorithmChanged();
        emit hashLengthChanged();
    }
}

bool AsyncHasher::asynchronous() const
{
    Q_D(const AsyncHasher);

    return d->m_asynchronous;
}

void AsyncHasher::setAsynchronous(bool async)
{
    Q_D(AsyncHasher);

    if (d->m_asynchronous != async) {
        d->m_asynchronous = async;
        emit asynchronousChanged();
    }
}

QString AsyncHasher::hashValue() const
{
    Q_D(const AsyncHasher);

    return d->m_hashValue;
}

int AsyncHasher::hashLength() const
{
    Q_D(const AsyncHasher);

    return QCryptographicHash::hashLength(d->m_algorithm);
}

QUrl AsyncHasher::source() const
{
    Q_D(const AsyncHasher);

    return d->m_source;
}

void AsyncHasher::setSource(const QUrl &source)
{
    Q_D(AsyncHasher);

    if (d->m_source != source) {
        d->m_source = source;
        emit sourceChanged();

        d->cleanupRunnable();

        if (source.isLocalFile()) {
            QFile *file = new QFile(source.toLocalFile());
            if (file->open(QIODevice::ReadOnly)) {
                emit started();
                if (d->m_asynchronous) {
                    d->m_runnable = new AsyncRunnable(file, d->m_algorithm);
                    connect(d->m_runnable, &AsyncRunnable::finished, this, &AsyncHasher::setHashValue, Qt::QueuedConnection);
                    connect(d->m_runnable, &AsyncRunnable::progress, this, &AsyncHasher::hashProgress, Qt::QueuedConnection);
                    QThreadPool::globalInstance()->start(d->m_runnable);
                    emit started();
                } else {
                    QCryptographicHash hash(d->m_algorithm);
                    hash.addData(file);
                    setHashValue(hash.result().toHex().toUpper());
                    file->deleteLater();
                }
            } else {
                qWarning() << "File Error:" << file->errorString();
                file->deleteLater();
            }
        } else {
            if (d->m_reply)
                d->m_reply->abort();
            emit started();
            d->m_reply = d->m_manager.get(QNetworkRequest(source));
            connect(d->m_reply, &QNetworkReply::finished, this, [d, this]{
                if (d->m_reply->error() == QNetworkReply::NoError) {
                    if (d->m_asynchronous) {
                        d->m_runnable = new AsyncRunnable(d->m_reply, d->m_algorithm);
                        connect(d->m_runnable, &AsyncRunnable::finished, this, &AsyncHasher::setHashValue, Qt::QueuedConnection);
                        connect(d->m_runnable, &AsyncRunnable::progress, this, &AsyncHasher::hashProgress, Qt::QueuedConnection);
                        QThreadPool::globalInstance()->start(d->m_runnable);
                    } else {
                        QCryptographicHash hash(d->m_algorithm);
                        hash.addData(d->m_reply);
                        setHashValue(hash.result().toHex().toUpper());
                        d->m_reply->deleteLater();
                    }
                } else {
                    qWarning() << "HTTP Request Error:" << d->m_reply->errorString();
                    d->m_reply->deleteLater();
                }
                d->m_reply = nullptr;
            });
        }
    }
}

QString AsyncHasher::sourceText() const
{
    Q_D(const AsyncHasher);

    return d->m_sourceText;
}

void AsyncHasher::setSourceText(const QString &sourceText)
{
    Q_D(AsyncHasher);

    if (d->m_sourceText != sourceText) {
        d->m_sourceText = sourceText;
        emit sourceTextChanged();

        d->cleanupRunnable();

        emit started();
        if (d->m_asynchronous) {
            QBuffer *buffer = new QBuffer;
            buffer->setData(sourceText.toUtf8());
            buffer->open(QIODevice::ReadOnly);
            d->m_runnable = new AsyncRunnable(buffer, d->m_algorithm);
            connect(d->m_runnable, &AsyncRunnable::finished, this, &AsyncHasher::setHashValue, Qt::QueuedConnection);
            connect(d->m_runnable, &AsyncRunnable::progress, this, &AsyncHasher::hashProgress, Qt::QueuedConnection);
            QThreadPool::globalInstance()->start(d->m_runnable);
        } else {
            QCryptographicHash hash(d->m_algorithm);
            hash.addData(sourceText.toUtf8());
            setHashValue(hash.result().toHex().toUpper());
        }
    }
}

QByteArray AsyncHasher::sourceData() const
{
    Q_D(const AsyncHasher);

    return d->m_sourceData;
}

void AsyncHasher::setSourceData(const QByteArray &sourceData)
{
    Q_D(AsyncHasher);

    if (d->m_sourceData != sourceData) {
        d->m_sourceData = sourceData;
        emit sourceDataChanged();

        d->cleanupRunnable();

        emit started();
        if (d->m_asynchronous) {
            QBuffer *buffer = new QBuffer;
            buffer->setData(sourceData);
            buffer->open(QIODevice::ReadOnly);
            d->m_runnable = new AsyncRunnable(buffer, d->m_algorithm);
            connect(d->m_runnable, &AsyncRunnable::finished, this, &AsyncHasher::setHashValue, Qt::QueuedConnection);
            connect(d->m_runnable, &AsyncRunnable::progress, this, &AsyncHasher::hashProgress, Qt::QueuedConnection);
            QThreadPool::globalInstance()->start(d->m_runnable);
        } else {
            QCryptographicHash hash(d->m_algorithm);
            hash.addData(sourceData);
            setHashValue(hash.result().toHex().toUpper());
        }
    }
}

QObject *AsyncHasher::sourceObject() const
{
    Q_D(const AsyncHasher);

    return d->m_sourceObject;
}

void AsyncHasher::setSourceObject(QObject *sourceObject)
{
    Q_D(AsyncHasher);

    if (d->m_sourceObject != sourceObject) {
        d->m_sourceObject = sourceObject;
        emit sourceObjectChanged();
        emit started();
        setHashValue(QCryptographicHash::hash(QByteArray::number(qHash(sourceObject)), d->m_algorithm).toHex().toUpper());
    }
}

void AsyncHasher::setHashValue(const QString &value)
{
    Q_D(AsyncHasher);

    d->m_hashValue = value;
    emit hashValueChanged();
    emit finished();
}

bool AsyncHasher::operator==(const AsyncHasher &hasher)
{
    Q_D(const AsyncHasher);

    return hasher.d_func()->m_hashValue == d->m_hashValue;
}

bool AsyncHasher::operator!=(const AsyncHasher &hasher)
{
    return !(*this == hasher);
}

QFuture<QByteArray> AsyncHasher::hash(const QByteArray &data, QCryptographicHash::Algorithm algorithm)
{
    return QtConcurrent::run([data, algorithm]()->QByteArray{
        return QCryptographicHash::hash(data, algorithm);
    });
}

#include "asynchasher.moc"
