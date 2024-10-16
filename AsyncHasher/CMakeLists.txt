project(AsyncHasher VERSION 1.0 LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

find_package(QT NAMES Qt6 Qt5 REQUIRED COMPONENTS Quick Concurrent)
find_package(Qt${QT_VERSION_MAJOR} REQUIRED COMPONENTS Quick Concurrent)

set(SOURCES main.cpp asynchasher.h asynchasher.cpp)

qt5_add_resources(SOURCES qml.qrc)

add_executable(AsyncHasher ${SOURCES})

target_link_libraries(AsyncHasher PRIVATE
    Qt::Quick
    Qt::Concurrent
)
