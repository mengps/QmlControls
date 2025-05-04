cmake_minimum_required(VERSION 3.16)

set(DELEGATEUI_VERSION 0.2.9.0)

message(STATUS "Configuring DelegateUI Version: ${DELEGATEUI_VERSION}")

project(DelegateUI VERSION ${DELEGATEUI_VERSION} LANGUAGES CXX)

#Add DeleagteUIHelper
include(${CMAKE_CURRENT_LIST_DIR}/../.cmake/DelegateUIHelper.cmake)
#Add QmlPluginHelper
include(${CMAKE_CURRENT_LIST_DIR}/../.cmake/QmlPluginHelper.cmake)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_STANDARD 17)

find_package(Qt5 COMPONENTS Quick REQUIRED)

#Set plugin output dir
set(QT_SDK_DIR "${Qt${QT_VERSION_MAJOR}_DIR}/../../..")
cmake_path(SET QT_SDK_DIR NORMALIZE ${QT_SDK_DIR})
set(DELEGATEUI_LIBRARY_OUTPUT_DIRECTORY "" CACHE PATH "DelegateUI library output dir.")
set(DELEGATEUI_PLUGIN_OUTPUT_DIRECTORY "" CACHE PATH "DelegateUI plugin output dir.")
if(NOT DELEGATEUI_PLUGIN_OUTPUT_DIRECTORY)
    set(DELEGATEUI_LIBRARY_OUTPUT_DIRECTORY ${Qt5_DIR}/../../../)
    set(DELEGATEUI_PLUGIN_OUTPUT_DIRECTORY ${Qt5_DIR}/../../../qml/DelegateUI)
    if(BUILD_DELEGATEUI_STATIC_LIBRARY)
        set(DELEGATEUI_PLUGIN_OUTPUT_DIRECTORY ${CMAKE_SOURCE_DIR}/DelegateUI)
    endif()
endif()

set(LIBRARY_TYPE "")
if(BUILD_DELEGATEUI_STATIC_LIBRARY)
    set(LIBRARY_TYPE "STATIC")
else()
    set(LIBRARY_TYPE "SHARED")
endif()

set(DELEGATEUI_RC_FILE "")
if(WIN32)
    set(DELEGATEUI_RC_FILE ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}_Resource.rc)
    set(RC_NAME "")
    if(BUILD_DELEGATEUI_STATIC_LIBRARY)
        set(RC_NAME "${PROJECT_NAME}.lib")
    else()
        set(RC_NAME "${PROJECT_NAME}.dll")
    endif()
    del_add_win_rc(${PROJECT_NAME}
        COMMENTS "Modern UI-Kit for Qml { Design reference Ant-d }"
        NAME ${RC_NAME}
        COMPANY "DelegateUI"
        DESCRIPTION "https://github.com/mengps/DelegateUI"
        VERSION "${PROJECT_VERSION}"
        COPYRIGHT "Copyright (C) 2025 mengps. All rights reserved."
        OUTPUT_FILE "${DELEGATEUI_RC_FILE}"
    )
endif()

del_get_dir_sources(FILTER "qml/*.qml" OUTPUT QML_SOURCES)
del_get_dir_sources(FILTER "cpp/*.h" "cpp/*.cpp" OUTPUT CPP_SOURCES)

qt5_add_resources(QRC_SOURCES qml.qrc theme.qrc resource.qrc shaders.qrc)

add_qmlplugin(${PROJECT_NAME}
    URI "DelegateUI"
    VERSION 1.0
    SOURCES ${CPP_SOURCES} ${QRC_SOURCES}
    QMLFILES ${QML_SOURCES}
    QMLDIR imports/DelegateUI
    BINARY_DIR ${DELEGATEUI_PLUGIN_OUTPUT_DIRECTORY}
    LIBTYPE ${LIBRARY_TYPE}
)

if(MINGW)
    set_target_properties(${PROJECT_NAME} PROPERTIES PREFIX "")
    target_compile_options(${PROJECT_NAME} PRIVATE -Wa,-mbig-obj)
elseif(MSVC)
    set_target_properties(${PROJECT_NAME} PROPERTIES DEBUG_POSTFIX "d")
    target_compile_options(${PROJECT_NAME} PRIVATE $<$<CXX_COMPILER_ID:MSVC>:/utf-8;/Zi>)
endif()

target_compile_definitions(${PROJECT_NAME} PRIVATE
    BUILD_DELEGATEUI_LIB
    DELEGATEUI_LIBRARY_VERSION="${DELEGATEUI_VERSION}"
    $<$<BOOL:${BUILD_DELEGATEUI_STATIC_LIBRARY}>:BUILD_DELEGATEUI_STATIC_LIBRARY>
    $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>
)

target_link_libraries(${PROJECT_NAME} PRIVATE
    Qt::Quick
    Qt::QuickPrivate
    QWKCore
    QWKQuick
)

target_include_directories(${PROJECT_NAME} PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${CMAKE_CURRENT_SOURCE_DIR}/cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/cpp/theme
    ${CMAKE_CURRENT_SOURCE_DIR}/cpp/controls
    ${CMAKE_CURRENT_SOURCE_DIR}/cpp/utils
)

install(TARGETS ${PROJECT_NAME}
    RUNTIME DESTINATION ${CMAKE_INSTALL_PREFIX}/DelegateUI/bin
    ARCHIVE DESTINATION ${CMAKE_INSTALL_PREFIX}/DelegateUI/lib
    LIBRARY DESTINATION ${CMAKE_INSTALL_PREFIX}/DelegateUI/lib
)

install(
    FILES cpp/delglobal.h cpp/delapp.h cpp/deldefinitions.h
    DESTINATION ${CMAKE_INSTALL_PREFIX}/DelegateUI/include
)

install(
    DIRECTORY cpp/controls cpp/theme cpp/utils
    DESTINATION ${CMAKE_INSTALL_PREFIX}/DelegateUI/include
    FILES_MATCHING PATTERN "*.h"
    PATTERN "*_p.h" EXCLUDE
)

install(
    DIRECTORY ${DELEGATEUI_PLUGIN_OUTPUT_DIRECTORY} DESTINATION ${CMAKE_INSTALL_PREFIX}/DelegateUI/imports
)
