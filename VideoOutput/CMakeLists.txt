project(VideoOutput VERSION 1.0 LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

find_package(QT NAMES Qt6 Qt5 REQUIRED COMPONENTS Quick Multimedia)
find_package(Qt${QT_VERSION_MAJOR} REQUIRED COMPONENTS Quick Multimedia)

set(SOURCES main.cpp videoframeprovider.h videoframeprovider.cpp)

qt5_add_resources(SOURCES qml.qrc)

add_executable(VideoOutput ${SOURCES})

target_link_libraries(VideoOutput PRIVATE
    Qt::Quick
    Qt::Multimedia
)
