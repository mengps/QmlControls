cmake_minimum_required(VERSION 3.16)

project(MagicFish VERSION 1.0 LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

find_package(QT NAMES Qt6 Qt5 REQUIRED COMPONENTS Quick)
find_package(Qt${QT_VERSION_MAJOR} REQUIRED COMPONENTS Quick)

set(SOURCES main.cpp magicpool.h magicpool.cpp magicfish.h magicfish.cpp)

qt5_add_resources(SOURCES qml.qrc)

add_executable(MagicFish ${SOURCES})

target_link_libraries(MagicFish PRIVATE
    Qt::Quick
)
