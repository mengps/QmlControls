#ifndef FRAMELESSWINDOW_H
#define FRAMELESSWINDOW_H

#include <QQuickWindow>

class FramelessWindow : public QQuickWindow
{
    Q_OBJECT

    Q_PROPERTY(bool resizable READ resizable WRITE setResizable NOTIFY resizableChanged)

public:
    explicit FramelessWindow(QWindow *parent = nullptr);

    bool resizable() const;
    void setResizable(bool resizable);

signals:
    void resizableChanged();

protected:
    bool nativeEvent(const QByteArray &eventType, void *message, long *result) override;

private:
    bool m_resizable = true;
    QRect m_moveArea = {8, 8, width() - 16, 35};
};

#endif // FRAMELESSWINDOW_H
