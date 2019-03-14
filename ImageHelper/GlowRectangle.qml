import QtQuick 2.12
import QtGraphicalEffects 1.12

Item
{
    id: root

    property alias color: backRect.color;
    property alias radius: backRect.radius;
    property alias spread: backEffect.spread;
    property alias glowColor: backEffect.color;
    property alias glowRadius: backEffect.glowRadius;

    RectangularGlow
    {
        id: backEffect
        anchors.fill: backRect
        glowRadius: 0
        spread: 0.2
        cornerRadius: backRect.radius + glowRadius
    }

    Rectangle
    {
        id: backRect
        anchors.fill: parent
    }
}
