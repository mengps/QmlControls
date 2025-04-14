cmake_minimum_required(VERSION 3.16)

project(QmlControls)

set(BUILD_OUTPUT_DIRECTORY ${CMAKE_SOURCE_DIR}/bin)

#Others
add_subdirectory(GlowCircularImage)
add_subdirectory(MagicFish)
add_subdirectory(EditorImageHelper)
if (WIN32)
    add_subdirectory(FramelessWindow/framelesswindow_win)
endif()
add_subdirectory(FramelessWindow/framelesswindow_all)
add_subdirectory(PolygonWindow)
add_subdirectory(HistoryEditor)
add_subdirectory(VideoOutput)
add_subdirectory(FpsItem)
add_subdirectory(ColorPicker)
add_subdirectory(WaterfallFlow)
add_subdirectory(Notification)
add_subdirectory(WaveProgress)

# Deploy Script
if(CMAKE_BUILD_TYPE MATCHES "Release")
    if(APPLE)
        find_program(QT_DEPLOY_QT NAMES macdeployqt)
        add_custom_target(Script-DeployRelease
                COMMAND ${CMAKE_COMMAND} -E remove_directory ${CMAKE_SOURCE_DIR}/package
                COMMAND ${CMAKE_COMMAND} -E copy_directory ${BUILD_OUTPUT_DIRECTORY} ${CMAKE_SOURCE_DIR}/package
                COMMAND ${QT_DEPLOY_QT} ${CMAKE_SOURCE_DIR}/package/GlowCircularImage.app -qmldir=GlowCircularImage
                COMMAND ${QT_DEPLOY_QT} ${CMAKE_SOURCE_DIR}/package/MagicFish.app -qmldir=MagicFish
                COMMAND ${QT_DEPLOY_QT} ${CMAKE_SOURCE_DIR}/package/EditorImageHelper.app -qmldir=EditorImageHelper
                COMMAND ${QT_DEPLOY_QT} ${CMAKE_SOURCE_DIR}/package/framelesswindow_all.app -qmldir=FramelessWindow/framelesswindow_all
                COMMAND ${QT_DEPLOY_QT} ${CMAKE_SOURCE_DIR}/package/PolygonWindow.app -qmldir=PolygonWindow
                COMMAND ${QT_DEPLOY_QT} ${CMAKE_SOURCE_DIR}/package/HistoryEditor.app -qmldir=HistoryEditor
                COMMAND ${QT_DEPLOY_QT} ${CMAKE_SOURCE_DIR}/package/VideoOutput.app -qmldir=VideoOutput
                COMMAND ${QT_DEPLOY_QT} ${CMAKE_SOURCE_DIR}/package/FpsItem.app -qmldir=FpsItem
                COMMAND ${QT_DEPLOY_QT} ${CMAKE_SOURCE_DIR}/package/ColorPicker.app -qmldir=ColorPicker
                COMMAND ${QT_DEPLOY_QT} ${CMAKE_SOURCE_DIR}/package/WaterfallFlow.app -qmldir=WaterfallFlow
                COMMAND ${QT_DEPLOY_QT} ${CMAKE_SOURCE_DIR}/package/Notification.app -qmldir=Notification
                COMMAND ${QT_DEPLOY_QT} ${CMAKE_SOURCE_DIR}/package/WaveProgress.app -qmldir=WaveProgress
                COMMENT "MacOs Deploying Qt Dependencies After Build........."
                SOURCES ${CMAKE_SOURCE_DIR}/CMakeLists.txt
                WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
        )
    endif()
    if(WIN32)
        find_program(QT_DEPLOY_QT NAMES windeployqt)
        add_custom_target(Script-DeployRelease
                COMMAND ${CMAKE_COMMAND} -E remove_directory ${CMAKE_SOURCE_DIR}/package
                COMMAND ${CMAKE_COMMAND} -E copy_directory ${BUILD_OUTPUT_DIRECTORY} ${CMAKE_SOURCE_DIR}/package
                COMMAND ${QT_DEPLOY_QT} --qmldir=GlowCircularImage --no-translations --compiler-runtime ${CMAKE_SOURCE_DIR}/package/GlowCircularImage.exe
                COMMAND ${QT_DEPLOY_QT} --qmldir=MagicFish --no-translations --compiler-runtime ${CMAKE_SOURCE_DIR}/package/MagicFish.exe
                COMMAND ${QT_DEPLOY_QT} --qmldir=EditorImageHelper --no-translations --compiler-runtime ${CMAKE_SOURCE_DIR}/package/EditorImageHelper.exe
                COMMAND ${QT_DEPLOY_QT} --qmldir=FramelessWindow/framelesswindow_all --no-translations --compiler-runtime ${CMAKE_SOURCE_DIR}/package/framelesswindow_all.exe
                COMMAND ${QT_DEPLOY_QT} --qmldir=PolygonWindow --no-translations --compiler-runtime ${CMAKE_SOURCE_DIR}/package/PolygonWindow.exe
                COMMAND ${QT_DEPLOY_QT} --qmldir=HistoryEditor --no-translations --compiler-runtime ${CMAKE_SOURCE_DIR}/package/HistoryEditor.exe
                COMMAND ${QT_DEPLOY_QT} --qmldir=VideoOutput --no-translations --compiler-runtime ${CMAKE_SOURCE_DIR}/package/VideoOutput.exe
                COMMAND ${QT_DEPLOY_QT} --qmldir=FpsItem --no-translations --compiler-runtime ${CMAKE_SOURCE_DIR}/package/FpsItem.exe
                COMMAND ${QT_DEPLOY_QT} --qmldir=ColorPicker --no-translations --compiler-runtime ${CMAKE_SOURCE_DIR}/package/ColorPicker.exe
                COMMAND ${QT_DEPLOY_QT} --qmldir=WaterfallFlow --no-translations --compiler-runtime ${CMAKE_SOURCE_DIR}/package/WaterfallFlow.exe
                COMMAND ${QT_DEPLOY_QT} --qmldir=Notification --no-translations --compiler-runtime ${CMAKE_SOURCE_DIR}/package/Notification.exe
                COMMAND ${QT_DEPLOY_QT} --qmldir=WaveProgress --no-translations --compiler-runtime ${CMAKE_SOURCE_DIR}/package/WaveProgress.exe
                COMMENT "Windows Deploying Qt Dependencies After Build........."
                SOURCES ${CMAKE_SOURCE_DIR}/CMakeLists.txt
                WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
        )
    endif()
endif()
