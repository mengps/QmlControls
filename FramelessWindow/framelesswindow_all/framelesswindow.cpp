#include "framelesswindow.h"

FramelessWindow::FramelessWindow(QWindow *parent)
    : QQuickWindow (parent)

{
   setFlags(flags() | Qt::Window | Qt::FramelessWindowHint);

   //在这里改变默认移动区域
   //只有鼠标在移动区域内，才能移动窗口
   connect(this, &QQuickWindow::widthChanged, this, [this](int arg){
       m_moveArea.setWidth(arg - 16);
   });
}

bool FramelessWindow::movable() const
{
    return m_movable;
}

void FramelessWindow::setMovable(bool arg)
{
    if (m_movable != arg) {
        m_movable = arg;
        emit movableChanged();
    }
}

bool FramelessWindow::resizable() const
{
    return m_resizable;
}

void FramelessWindow::setResizable(bool arg)
{
    if (m_resizable != arg) {
        m_resizable = arg;
        emit resizableChanged();
    }
}

void FramelessWindow::mousePressEvent(QMouseEvent *event)
{
    m_startPos = event->globalPos();
    m_oldPos = position();
    m_oldSize = size();

    event->ignore();

    QQuickWindow::mousePressEvent(event);
}

void FramelessWindow::mouseReleaseEvent(QMouseEvent *event)
{
    m_oldPos = position();

    QQuickWindow::mouseReleaseEvent(event);
}

void FramelessWindow::mouseDoubleClickEvent(QMouseEvent *event)
{
    if (m_currentArea == Move) {
        if (windowState() == Qt::WindowMaximized) {
            showNormal();
            m_currentArea = Client;
        }
        else if (windowState() == Qt::WindowNoState) {
            showMaximized();
            m_currentArea = Client;
        }
    }

    QQuickWindow::mouseDoubleClickEvent(event);
}

void FramelessWindow::mouseMoveEvent(QMouseEvent *event)
{
    if (event->buttons() & Qt::LeftButton) {
        if (m_movable && m_currentArea == Move) {
            //单独处理移动区域，这样可以更快
            //但是需要注意，z序更高的MouseArea仍会触发
            setPosition(m_oldPos - m_startPos + event->globalPos());
        } else if (m_resizable && m_currentArea != Move){
            setWindowGeometry(event->globalPos());
        }
    } else {
        QPoint pos = event->pos();
        m_currentArea = getArea(pos);
        if (m_resizable) setCursorIcon();
    }

    QQuickWindow::mouseMoveEvent(event);
}

FramelessWindow::MouseArea FramelessWindow::getArea(const QPoint &pos)
{
    int x = pos.x();
    int y = pos.y();
    int w = width();
    int h = height();
    MouseArea area;

    if (x >= 0 && x <= 8 && y >= 0 && y <= 8) {
        area = TopLeft;
    } else if (x > 8 && x < (w - 8) && y >= 0 && y <= 8) {
        area = Top;
    } else if (x >=(w - 8) && x <= w && y >= 0 && y <= 8) {
        area = TopRight;
    } else if (x >= 0 && x <= 8 && y > 8 && y < (h - 8)) {
        area = Left;
    } else if (x >=(w - 8) && x <= w && y > 8 && y < (h - 8)) {
        area = Right;
    } else if (x >= 0 && x <= 8 && y >= (h - 8) && y <= h) {
        area = BottomLeft;
    } else if (x > 8 && x < (w - 8) && y >= (h - 8) && y <= h) {
        area = Bottom;
    } else if (x >=(w - 8) && x <= w && y >= (h - 8) && y <= h) {
        area = BottomRight;
    } else if (m_moveArea.contains(x, y)) {
        area = Move;
    } else {
        area = Client;
    }

    return area;
}

void FramelessWindow::setWindowGeometry(const QPoint &pos)
{
    QPoint offset = m_startPos - pos;

    if (offset.x() == 0 && offset.y() == 0)
        return;

    static auto set_geometry_func = [this](const QSize &size, const QPoint &pos) {
        QPoint temp_pos = m_oldPos;
        QSize temp_size = minimumSize();
        if (size.width() > minimumWidth()) {
            temp_pos.setX(pos.x());
            temp_size.setWidth(size.width());
        } else {
            //防止瞬间拉过头，会导致错误的计算位置，这里纠正
            if (pos.x() != temp_pos.x())
                temp_pos.setX(m_oldPos.x() +  m_oldSize.width() - minimumWidth());
        }
        if (size.height() > minimumHeight()) {
            temp_pos.setY(pos.y());
            temp_size.setHeight(size.height());
        } else {
            //防止瞬间拉过头，会导致错误的计算位置，这里纠正
            if (pos.y() != temp_pos.y())
                temp_pos.setY(m_oldPos.y() + m_oldSize.height() - minimumHeight());
        }
        setGeometry(QRect(temp_pos, temp_size));
        update();
    };

    switch (m_currentArea) {
    case TopLeft:
        set_geometry_func(m_oldSize + QSize(offset.x(), offset.y()), m_oldPos - offset);
        break;
    case Top:
        set_geometry_func(m_oldSize + QSize(0, offset.y()), m_oldPos - QPoint(0, offset.y()));
        break;
    case TopRight:
        set_geometry_func(m_oldSize - QSize(offset.x(), -offset.y()), m_oldPos - QPoint(0, offset.y()));
        break;
    case Left:
        set_geometry_func(m_oldSize + QSize(offset.x(), 0), m_oldPos - QPoint(offset.x(), 0));;
        break;
    case Right:
        set_geometry_func(m_oldSize - QSize(offset.x(), 0), position());
        break;
    case BottomLeft:
        set_geometry_func(m_oldSize + QSize(offset.x(), -offset.y()), m_oldPos - QPoint(offset.x(), 0));
        break;
    case Bottom:
        set_geometry_func(m_oldSize + QSize(0, -offset.y()), position());
        break;
    case BottomRight:
        set_geometry_func(m_oldSize - QSize(offset.x(), offset.y()), position());
        break;
    default:
        break;
    }
}

void FramelessWindow::setCursorIcon()
{
    static bool unset = false;

    switch (m_currentArea) {
    case TopLeft:
    case BottomRight:
        unset = true;
        setCursor(Qt::SizeFDiagCursor);
        break;
    case Top:
    case Bottom:
        unset = true;
        setCursor(Qt::SizeVerCursor);
        break;
    case TopRight:
    case BottomLeft:
        unset = true;
        setCursor(Qt::SizeBDiagCursor);
        break;
    case Left:
    case Right:
        unset = true;
        setCursor(Qt::SizeHorCursor);
        break;
    case Move:
        unset = true;
        setCursor(Qt::ArrowCursor);
        break;
    default:
        if (unset) {
            unset = false;
            unsetCursor();
        }
        break;
    }
}

