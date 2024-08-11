#ifndef ASYNCHASHER_H
#define ASYNCHASHER_H

#include <QCryptographicHash>
#include <QFuture>
#include <QObject>
#include <QUrl>

QT_FORWARD_DECLARE_CLASS(QNetworkAccessManager);

QT_FORWARD_DECLARE_CLASS(AsyncHasherPrivate);

class AsyncHasher : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QCryptographicHash::Algorithm algorithm READ algorithm WRITE setAlgorithm NOTIFY algorithmChanged)
    Q_PROPERTY(bool asynchronous READ asynchronous WRITE setAsynchronous NOTIFY asynchronousChanged)
    Q_PROPERTY(QString hashValue READ hashValue NOTIFY hashValueChanged)
    Q_PROPERTY(int hashLength READ hashLength NOTIFY hashLengthChanged)
    Q_PROPERTY(QUrl source READ source WRITE setSource NOTIFY sourceChanged)
    Q_PROPERTY(QString sourceText READ sourceText WRITE setSourceText NOTIFY sourceTextChanged)
    Q_PROPERTY(QByteArray sourceData READ sourceData WRITE setSourceData NOTIFY sourceDataChanged)
    Q_PROPERTY(QObject* sourceObject READ sourceObject WRITE setSourceObject NOTIFY sourceObjectChanged)

public:
    Q_ENUMS(QCryptographicHash::Algorithm);

    explicit AsyncHasher(QObject *parent = nullptr);
    ~AsyncHasher();

    QNetworkAccessManager *networkManager() const;

    QCryptographicHash::Algorithm algorithm();
    void setAlgorithm(QCryptographicHash::Algorithm algorithm);

    bool asynchronous() const;
    void setAsynchronous(bool async);

    QString hashValue() const;

    int hashLength() const;

    QUrl source() const;
    void setSource(const QUrl &source);

    QString sourceText() const;
    void setSourceText(const QString &sourceText);

    QByteArray sourceData() const;
    void setSourceData(const QByteArray &sourceData);

    QObject *sourceObject() const;
    void setSourceObject(QObject *sourceObject);

    bool operator==(const AsyncHasher &hasher);
    bool operator!=(const AsyncHasher &hasher);

    QFuture<QByteArray> static hash(const QByteArray &data, QCryptographicHash::Algorithm algorithm);

signals:
    void algorithmChanged();
    void asynchronousChanged();
    void hashValueChanged();
    void hashLengthChanged();
    void sourceChanged();
    void sourceTextChanged();
    void sourceDataChanged();
    void sourceObjectChanged();
    void hashProgress(qint64 processed, qint64 total);
    void started();
    void finished();

private slots:
    void setHashValue(const QString &value);

private:
    Q_DECLARE_PRIVATE(AsyncHasher);
    QScopedPointer<AsyncHasherPrivate> d_ptr;
};

#endif // ASYNCHASHER_H
