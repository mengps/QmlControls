project(SystemThemeHelper VERSION 1.0 LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

find_package(QT NAMES Qt6 Qt5 REQUIRED COMPONENTS Quick)
find_package(Qt${QT_VERSION_MAJOR} REQUIRED COMPONENTS Quick)

set(SOURCES main.cpp systemthemehelper.h systemthemehelper.cpp)

qt_add_resources(SOURCES qml.qrc)

add_executable(SystemThemeHelper ${SOURCES})

target_link_libraries(SystemThemeHelper PRIVATE
    Qt${QT_VERSION_MAJOR}::Quick
)
