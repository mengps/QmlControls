cmake_minimum_required(VERSION 3.16)

project(DelAsyncHasher VERSION 1.0 LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

find_package(QT NAMES Qt6 Qt5 REQUIRED COMPONENTS Quick Concurrent)
find_package(Qt${QT_VERSION_MAJOR} REQUIRED COMPONENTS Quick Concurrent)

set(SOURCES main.cpp delasynchasher.h delasynchasher.cpp)

qt5_add_resources(SOURCES qml.qrc)

add_executable(DelAsyncHasher ${SOURCES})

target_link_libraries(DelAsyncHasher PRIVATE
    Qt::Quick
    Qt::Concurrent
)
