#ifndef IMAGEHELPER_H
#define IMAGEHELPER_H

#include <QMovie>
#include <QTextCursor>
#include <QQuickWindow>

class Api : public QObject
{
    Q_OBJECT

public:
    Api(QObject *parent = nullptr);

    Q_INVOKABLE bool exists(const QString &arg);
    Q_INVOKABLE QString baseName(const QString &arg);
};

class QQuickTextDocument;
class ImageHelper : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QQuickTextDocument* document READ document WRITE setDocument NOTIFY documentChanged)
    Q_PROPERTY(int cursorPosition READ cursorPosition WRITE setCursorPosition NOTIFY cursorPositionChanged)
    Q_PROPERTY(int selectionStart READ selectionStart WRITE setSelectionStart NOTIFY selectionStartChanged)
    Q_PROPERTY(int selectionEnd READ selectionEnd WRITE setSelectionEnd NOTIFY selectionEndChanged)
    //用于控制插入的图片的最大宽/高
    Q_PROPERTY(int maxWidth READ maxWidth WRITE setMaxWidth NOTIFY maxWidthChanged)
    Q_PROPERTY(int maxHeight READ maxHeight WRITE setMaxHeight NOTIFY maxHeightChanged)

public:
    ImageHelper(QObject *parent = nullptr);
    ~ImageHelper();

    Q_INVOKABLE void insertImage(const QUrl &url);
    Q_INVOKABLE void cleanup();

    QQuickTextDocument* document() const;
    void setDocument(QQuickTextDocument *document);

    int cursorPosition() const;
    void setCursorPosition(int position);

    int selectionStart() const;
    void setSelectionStart(int position);

    int selectionEnd() const;
    void setSelectionEnd(int position);

    int maxWidth() const;
    void setMaxWidth(int max);

    int maxHeight() const;
    void setMaxHeight(int max);

signals:
    void needUpdate();
    void documentChanged();
    void cursorPositionChanged();
    void selectionStartChanged();
    void selectionEndChanged();
    void maxWidthChanged();
    void maxHeightChanged();

private:
    QTextDocument *textDocument() const;
    QTextCursor textCursor() const;

private:
    QHash<QUrl, QMovie *> m_urls;
    QQuickTextDocument *m_document;
    int m_cursorPosition;
    int m_selectionStart;
    int m_selectionEnd;
    int m_maxWidth;
    int m_maxHeight;
};

#endif // IMAGEHELPER_H
