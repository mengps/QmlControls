cmake_minimum_required(VERSION 3.16)

project(ColorPicker VERSION 1.0 LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

find_package(QT NAMES Qt6 Qt5 REQUIRED COMPONENTS Quick)
find_package(Qt${QT_VERSION_MAJOR} REQUIRED COMPONENTS Quick)

set(SOURCES main.cpp)

qt5_add_resources(SOURCES qml.qrc)

add_executable(${PROJECT_NAME} ${SOURCES} ${CMAKE_SOURCE_DIR}/common/QmlControls_Resource.rc)

set_target_properties(${PROJECT_NAME} PROPERTIES 
    WIN32_EXECUTABLE TRUE
    RUNTIME_OUTPUT_DIRECTORY $<IF:$<BOOL:${BUILD_OUTPUT_DIRECTORY}>,${BUILD_OUTPUT_DIRECTORY},${CMAKE_RUNTIME_OUTPUT_DIRECTORY}>
)

target_link_libraries(${PROJECT_NAME} PRIVATE
    Qt::Quick
)
