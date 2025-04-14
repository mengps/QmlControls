#include "editorimagehelper.h"

#include <QFile>
#include <QFileInfo>
#include <QMovie>
#include <QQmlFile>
#include <QQuickTextDocument>
#include <QDebug>

Api::Api(QObject *parent)
    : QObject(parent)
{
}

bool Api::exists(const QString &arg)
{
    return QFile::exists(arg);
}

QString Api::baseName(const QString &arg)
{
    return QFileInfo(arg).baseName();
}

EditorImageHelper::EditorImageHelper(QObject *parent)
    : QObject(parent)
    , m_maxImageWidth(120)
    , m_maxImageHeight(120)
{

}

EditorImageHelper::~EditorImageHelper()
{
    cleanup();
}

void EditorImageHelper::insertImage(const QUrl &url)
{
    QImage image = QImage(QQmlFile::urlToLocalFileOrQrc(url));
    if (image.isNull()) {
        qDebug() << "不支持的图像格式";
        return;
    }
    QString filename = url.toString();
    QString suffix = QFileInfo(filename).suffix().toLower();
    //如果是动图，则单独处理
    if (suffix == "gif" || suffix == "webp") {
        QString gif = filename;
        if (gif.left(4) == "file")
            gif = gif.mid(8);
        else if (gif.left(3) == "qrc")
            gif = gif.mid(3);

        textCursor().insertHtml("<img src='" + url.toString() + "' width = " +
                                QString::number(qMin(m_maxImageWidth, image.width())) + " height = " +
                                QString::number(qMin(m_maxImageHeight, image.height()))+ "/>");
        textDocument()->addResource(QTextDocument::ImageResource, url, image);
        if (m_urls.contains(url))
            return;
        else {
            QMovie *movie = new QMovie(gif);
            movie->setCacheMode(QMovie::CacheNone);
            connect(movie, &QMovie::finished, movie, &QMovie::start);   //循环播放
            connect(movie, &QMovie::frameChanged, this, [url, this](int) {
                QMovie *movie = qobject_cast<QMovie *>(sender());
                textDocument()->addResource(QTextDocument::ImageResource, url, movie->currentPixmap());
            });
            m_urls[url] = movie;
            movie->start();

            //每秒25帧
            m_updateTimer.start(40, this);
        }
    } else {
        QTextImageFormat format;
        format.setName(filename);
        format.setWidth(qMin(m_maxImageWidth, image.width()));
        format.setHeight(qMin(m_maxImageHeight, image.height()));
        textCursor().insertImage(format);
    }
}

void EditorImageHelper::cleanup()
{
    for (auto it : qAsConst(m_urls))
        it->deleteLater();
    m_urls.clear();
    m_updateTimer.stop();

    if (textDocument())
        textDocument()->clear();
}

QQuickTextDocument* EditorImageHelper::document() const
{
    return  m_document;
}

void EditorImageHelper::setDocument(QQuickTextDocument *document)
{
    if (document != m_document) {
        m_document = document;
        emit documentChanged();
    }
}

int EditorImageHelper::cursorPosition() const
{
    return m_cursorPosition;
}

void EditorImageHelper::setCursorPosition(int position)
{
    if (position != m_cursorPosition) {
        m_cursorPosition = position;
        emit cursorPositionChanged();
    }
}

int EditorImageHelper::selectionStart() const
{
    return m_selectionStart;
}

void EditorImageHelper::setSelectionStart(int position)
{
    if (position != m_selectionStart) {
        m_selectionStart = position;
        emit selectionStartChanged();
    }
}

int EditorImageHelper::selectionEnd() const
{
    return m_selectionEnd;
}

void EditorImageHelper::setSelectionEnd(int position)
{
    if (position != m_selectionEnd) {
        m_selectionEnd = position;
        emit selectionEndChanged();
    }
}

int EditorImageHelper::maxImageWidth() const
{
    return m_maxImageWidth;
}

void EditorImageHelper::setMaxImageWidth(int max)
{
    if (max != m_maxImageWidth) {
        m_maxImageWidth = max;
        emit maxImageWidthChanged();
    }
}

int EditorImageHelper::maxImageHeight() const
{
    return m_maxImageHeight;
}

void EditorImageHelper::setMaxImageHeight(int max)
{
    if (max != m_maxImageHeight) {
        m_maxImageHeight = max;
        emit maxImageHeightChanged();
    }
}

void EditorImageHelper::timerEvent(QTimerEvent *)
{
    if (!m_urls.isEmpty()) {
        emit needUpdate();
    }
}

QTextDocument *EditorImageHelper::textDocument() const
{
    if (m_document)
        return m_document->textDocument();
    else return nullptr;
}

QTextCursor EditorImageHelper::textCursor() const
{
    QTextDocument *doc = textDocument();
    if (!doc)
        return QTextCursor();

    QTextCursor cursor = QTextCursor(doc);
    if (m_selectionStart != m_selectionEnd) {
        cursor.setPosition(m_selectionStart);
        cursor.setPosition(m_selectionEnd, QTextCursor::KeepAnchor);
    } else {
        cursor.setPosition(m_cursorPosition);
    }

    return cursor;
}
