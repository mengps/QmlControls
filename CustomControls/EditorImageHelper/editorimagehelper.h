#ifndef EDITORIMAGEHELPER_H
#define EDITORIMAGEHELPER_H

#include <QTextCursor>
#include <QQuickWindow>
#include <QBasicTimer>

class Api : public QObject
{
    Q_OBJECT

public:
    Api(QObject *parent = nullptr);

    Q_INVOKABLE bool exists(const QString &arg);
    Q_INVOKABLE QString baseName(const QString &arg);
};

class QQuickTextDocument;
class QBasicTimer;
class EditorImageHelper : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QQuickTextDocument* document READ document WRITE setDocument NOTIFY documentChanged)
    Q_PROPERTY(int cursorPosition READ cursorPosition WRITE setCursorPosition NOTIFY cursorPositionChanged)
    Q_PROPERTY(int selectionStart READ selectionStart WRITE setSelectionStart NOTIFY selectionStartChanged)
    Q_PROPERTY(int selectionEnd READ selectionEnd WRITE setSelectionEnd NOTIFY selectionEndChanged)
    //用于控制插入的图片的最大宽/高
    Q_PROPERTY(int maxImageWidth READ maxImageWidth WRITE setMaxImageWidth NOTIFY maxImageWidthChanged)
    Q_PROPERTY(int maxImageHeight READ maxImageHeight WRITE setMaxImageHeight NOTIFY maxImageHeightChanged)

public:
    EditorImageHelper(QObject *parent = nullptr);
    ~EditorImageHelper();

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

    int maxImageWidth() const;
    void setMaxImageWidth(int max);

    int maxImageHeight() const;
    void setMaxImageHeight(int max);

signals:
    void needUpdate();
    void documentChanged();
    void cursorPositionChanged();
    void selectionStartChanged();
    void selectionEndChanged();
    void maxImageWidthChanged();
    void maxImageHeightChanged();

protected:
    virtual void timerEvent(QTimerEvent *);

private:
    QTextDocument *textDocument() const;
    QTextCursor textCursor() const;

private:
    QBasicTimer m_updateTimer;
    QHash<QUrl, QMovie *> m_urls;
    QQuickTextDocument *m_document;
    int m_cursorPosition;
    int m_selectionStart;
    int m_selectionEnd;
    int m_maxImageWidth;
    int m_maxImageHeight;
};

#endif // EDITOREditorImageHelper_H
