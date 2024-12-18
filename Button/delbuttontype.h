#ifndef DELBUTTONTYPE_H
#define DELBUTTONTYPE_H

#include <QtQml/qqml.h>

namespace DelButtonType {
    Q_NAMESPACE

    enum class Type {
        Type_Default = 0,
        Type_Outlined = 1,
        Type_Primary = 2,
        Type_Filled = 3,
        Type_Text = 4
    };

    enum class Shape {
        Shape_Default = 0,
        Shape_Circle = 1
    };

    enum class IconPosition {
        Position_Start = 0,
        Position_End = 1
    };

    Q_ENUM_NS(Type);
    Q_ENUM_NS(Shape);
    Q_ENUM_NS(IconPosition);

    QML_NAMED_ELEMENT(DelButtonType);
}

#endif // DELBUTTONTYPE_H
