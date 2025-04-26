cmake_minimum_required(VERSION 3.16)

set(DELEGATEUI_VERSION 0.2.8.0)

project(Gallery VERSION ${DELEGATEUI_VERSION} LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_STANDARD 17)

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_SOURCE_DIR}/bin/${CMAKE_BUILD_TYPE})

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_STANDARD 17)

find_package(Qt5 COMPONENTS Quick REQUIRED)

#Add DeleagteUIHelper
include(${CMAKE_CURRENT_LIST_DIR}/../.cmake/DelegateUIHelper.cmake)
#Add QmlPluginHelper
include(${CMAKE_CURRENT_LIST_DIR}/../.cmake/QmlPluginHelper.cmake)

set(GALLERY_RC_FILE "")
if (WIN32)
    set(GALLERY_RC_FILE ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}_Resource.rc)
    del_add_win_rc(${PROJECT_NAME}
        COMMENTS "DelegateUI Gallery"
        NAME "${PROJECT_NAME}.exe"
        COMPANY "DelegateUI"
        DESCRIPTION ""
        VERSION "${PROJECT_VERSION}"
        COPYRIGHT "Copyright (C) 2025 mengps. All rights reserved."
        ICONS ../resources/delegateui_icon.ico
        OUTPUT_FILE "${GALLERY_RC_FILE}"
    )
endif()

del_get_dir_sources(FILTER "*.qml" OUTPUT QML_SOURCES)
del_get_dir_sources(FILTER "*.h" "*.cpp" OUTPUT CPP_SOURCES)

qt5_add_resources(QRC_SOURCES qml.qrc resource.qrc shaders.qrc)

add_executable(${PROJECT_NAME}
    ${QML_SOURCES} ${CPP_SOURCES} ${QRC_SOURCES} ${GALLERY_RC_FILE}
)

set_target_properties(${PROJECT_NAME} PROPERTIES
    MACOSX_BUNDLE_GUI_IDENTIFIER delegateui.com
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE  #VSCode 打印需要屏蔽此属性
)

target_include_directories(${PROJECT_NAME} PRIVATE
    cpp
)

target_link_libraries(${PROJECT_NAME} PRIVATE 
    Qt::Quick
    DelegateUI
)

if (BUILD_DELEGATEUI_STATIC_LIBRARY)
    target_compile_definitions(${PROJECT_NAME} PRIVATE BUILD_DELEGATEUI_STATIC_LIBRARY)
endif()

# Deploy Script
if(CMAKE_BUILD_TYPE MATCHES "Release")
    if(APPLE)
        find_program(QT_DEPLOY_QT NAMES macdeployqt)
        set(QT_DEPLOY_ARGS
            ${CMAKE_SOURCE_DIR}/package/${PROJECT_NAME}.app
            --qmldir=${CMAKE_CURRENT_LIST_DIR}/qml
            --no-opengl-sw
            --no-widgets
            --no-virtualkeyboard
            --no-quick3dutils
            --no-quickcontrols2windowsstyleimpl
            --no-quickcontrols2fusion
            --no-quickcontrols2fusionstyleimpl
            --no-quickcontrols2material
            --no-quickcontrols2materialstyleimpl
            --no-quickcontrols2universal
            --no-quickcontrols2universalstyleimpl
            --no-quickcontrols2imagine
            --no-quickcontrols2imaginestyleimpl
            --no-translations
        )
        add_custom_target(Script-DeployRelease
                COMMAND ${CMAKE_COMMAND} -E remove_directory ${CMAKE_SOURCE_DIR}/package
                COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_RUNTIME_OUTPUT_DIRECTORY} ${CMAKE_SOURCE_DIR}/package
                COMMAND ${QT_DEPLOY_QT} ${QT_DEPLOY_ARGS}
                COMMENT "MacOs Deploying Qt Dependencies After Build........."
                SOURCES ${CMAKE_CURRENT_SOURCE_DIR}/CMakeLists.txt
                WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
        )
        add_dependencies(Script-DeployRelease ${PROJECT_NAME})
    endif()
    if(WIN32)
        find_program(QT_DEPLOY_QT NAMES windeployqt)
        set(QT_DEPLOY_ARGS
            --qmldir=${CMAKE_CURRENT_LIST_DIR}/qml
            --plugindir=${CMAKE_SOURCE_DIR}/package/plugins
            --no-opengl-sw
            --no-widgets
            --no-virtualkeyboard
            --no-quick3dutils
            --no-quickcontrols2windowsstyleimpl
            --no-quickcontrols2fusion
            --no-quickcontrols2fusionstyleimpl
            --no-quickcontrols2material
            --no-quickcontrols2materialstyleimpl
            --no-quickcontrols2universal
            --no-quickcontrols2universalstyleimpl
            --no-quickcontrols2imagine
            --no-quickcontrols2imaginestyleimpl
            --no-translations
            --compiler-runtime
            ${CMAKE_SOURCE_DIR}/package/${PROJECT_NAME}.exe
        )
        add_custom_target(Script-DeployRelease
                COMMAND ${CMAKE_COMMAND} -E remove_directory ${CMAKE_SOURCE_DIR}/package
                COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_RUNTIME_OUTPUT_DIRECTORY} ${CMAKE_SOURCE_DIR}/package
                COMMAND ${CMAKE_COMMAND} -E rm -f "${CMAKE_SOURCE_DIR}/package/${PROJECT_NAME}.qmltypes"
                COMMAND ${CMAKE_COMMAND} -E rm -f "${CMAKE_SOURCE_DIR}/package/${PROJECT_NAME}_qml_module_dir_map.qrc"
                COMMAND ${CMAKE_COMMAND} -E rm -f "${CMAKE_SOURCE_DIR}/package/qmldir"
                COMMAND ${CMAKE_COMMAND} -E copy ${Qt6_DIR}/../../../bin/DelegateUI.dll ${CMAKE_SOURCE_DIR}/package
                COMMAND ${QT_DEPLOY_QT} ${QT_DEPLOY_ARGS}
                COMMENT "Windows Deploying Qt Dependencies After Build........."
                SOURCES ${CMAKE_CURRENT_SOURCE_DIR}/CMakeLists.txt
                WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
        )
        add_dependencies(Script-DeployRelease ${PROJECT_NAME})
    endif()
endif()
