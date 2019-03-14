import QtQuick 2.12

MouseArea
{
    hoverEnabled: true

    property var target: undefined;
    property point startPoint: Qt.point(0, 0);
    property point offsetPoint: Qt.point(0, 0);

    onPressed:
    {
        cursorShape = Qt.SizeAllCursor;
        startPoint = Qt.point(mouseX, mouseY);
    }
    onPositionChanged:
    {
        if(pressed)
        {
            offsetPoint = Qt.point(mouse.x - startPoint.x, mouse.y - startPoint.y);
            target.x = target.x + offsetPoint.x;
            target.y = target.y + offsetPoint.y;
        }
    }
    onReleased:
    {
        cursorShape = Qt.ArrowCursor;
    }
}
