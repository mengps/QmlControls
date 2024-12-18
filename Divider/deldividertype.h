#ifndef DELBUTTONTYPE_H
#define DELBUTTONTYPE_H

#include <QtQml/qqml.h>

namespace DelDividerType {
    Q_NAMESPACE

    enum class Align
    {
        Left = 0,
        Center = 1,
        Right = 2
    };

    enum class Style
    {
        SolidLine = 0,
        DashLine = 1
    };

    Q_ENUM_NS(Align);
    Q_ENUM_NS(Style);

    QML_NAMED_ELEMENT(DelDividerType);
}

#endif // DELBUTTONTYPE_H
