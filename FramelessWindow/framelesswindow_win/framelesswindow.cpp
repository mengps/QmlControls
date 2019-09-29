#include "framelesswindow.h"
#include <QGuiApplication>

#ifdef Q_OS_WIN
#include <windowsx.h>
#define aeroBorderlessFlag LONG(WS_THICKFRAME | WS_CAPTION | WS_SYSMENU | WS_MAXIMIZEBOX | WS_MINIMIZEBOX)
#endif

static QRect MoveArea;

FramelessWindow::FramelessWindow(QWindow *parent)
    : QQuickWindow (parent)
{
    setFlags(flags() | Qt::FramelessWindowHint);

#ifdef Q_OS_WIN
    HWND hwnd = reinterpret_cast<HWND>(winId());
    SetWindowLongPtr(hwnd, GWL_STYLE, aeroBorderlessFlag);
#endif
    //在这里改变默认移动区域
    //只有鼠标在移动区域内，才能移动窗口
    MoveArea = {8, 8, width() - 16, 100};
    connect(this, &QQuickWindow::widthChanged, this, [](int arg){
        MoveArea.setWidth(arg - 16);
    });
}

bool FramelessWindow::nativeEvent(const QByteArray &eventType, void *message, long *result)
{
#ifdef Q_OS_WIN
    MSG* msg = reinterpret_cast<MSG*>(message);
    switch(msg->message) {
    case WM_NCCALCSIZE:
    {
        *result = 0;
        return true;
    }
    case WM_NCHITTEST:
    {
        auto x = GET_X_LPARAM(msg->lParam) - this->x();
        auto y = GET_Y_LPARAM(msg->lParam) - this->y();
        auto w = width();
        auto h = height();

        if (x >= 0 && x <= 8 && y >= 0 && y <= 8) {
            *result = HTTOPLEFT;
            return true;
        } else if (x > 8 && x < (w - 8) && y >= 0 && y <= 8) {
            *result = HTTOP;
            return true;
        } else if (x >=(w - 8) && x <= w && y >= 0 && y <= 8) {
            *result = HTTOPRIGHT;
            return true;
        } else if (x >= 0 && x <= 8 && y > 8 && y < (h - 8)) {
            *result = HTLEFT;
            return true;
        } else if (x >=(w - 8) && x <= w && y > 8 && y < (h - 8)) {
            *result = HTRIGHT;
            return true;
        } else if (x >= 0 && x <= 8 && y >= (h - 8) && y <= h) {
            *result = HTBOTTOMLEFT;
            return true;
        } else if (x > 8 && x < (w - 8) && y >= (h - 8) && y <= h) {
            *result = HTBOTTOM;
            return true;
        } else if (x >=(w - 8) && x <= w && y >= (h - 8) && y <= h) {
            *result = HTBOTTOMRIGHT;
            return true;
        } else if (MoveArea.contains(x, y)){
            *result = HTCAPTION;
            return true;
        } else {
            *result = HTCLIENT;
            return true;
        }
    }
    default:
        break;
    }
#endif

    return QQuickWindow::nativeEvent(eventType, message, result);
}
