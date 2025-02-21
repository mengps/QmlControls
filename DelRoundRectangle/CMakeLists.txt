cmake_minimum_required(VERSION 3.16)

project(DelRoundRectangle VERSION 1.0 LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

find_package(QT NAMES Qt6 Qt5 REQUIRED COMPONENTS Quick Concurrent)
find_package(Qt${QT_VERSION_MAJOR} REQUIRED COMPONENTS Quick Concurrent)

set(SOURCES main.cpp delrectangle.h delrectangle.cpp)

qt5_add_resources(SOURCES qml.qrc)

add_executable(DelRoundRectangle ${SOURCES})

target_link_libraries(DelRoundRectangle PRIVATE
    Qt::Quick
    Qt::QuickPrivate
)
