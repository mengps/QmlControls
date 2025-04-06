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

#DelegateUI Qt5
add_subdirectory(DelResizeMouseArea)
add_subdirectory(DelAsyncHasher)
add_subdirectory(DelRate)
add_subdirectory(DelSystemThemeHelper)
add_subdirectory(DelWatermark)
add_subdirectory(DelTour)
add_subdirectory(DelButton)
add_subdirectory(DelDivider)
add_subdirectory(DelSwitch)
add_subdirectory(DelAcrylic)
add_subdirectory(DelRoundRectangle)
add_subdirectory(DelTabView)
add_subdirectory(DelRadio)
add_subdirectory(DelRadioBlock)
add_subdirectory(DelCheckBox)
add_subdirectory(DelInput)
add_subdirectory(DelOTPInput)
add_subdirectory(DelSlider)
add_subdirectory(DelScrollBar)
add_subdirectory(DelTimePicker)
add_subdirectory(DelDrawer)
add_subdirectory(DelCollapse)
add_subdirectory(DelAvatar)
add_subdirectory(DelCard)
add_subdirectory(DelToolTip)
add_subdirectory(DelPopup)
add_subdirectory(DelSelect)
add_subdirectory(DelPagination)
add_subdirectory(DelTimeline)
add_subdirectory(DelTag)
add_subdirectory(DelTableView)

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
                COMMAND ${QT_DEPLOY_QT} ${CMAKE_SOURCE_DIR}/package/DelResizeMouseArea.app -qmldir=DelResizeMouseArea
                COMMAND ${QT_DEPLOY_QT} ${CMAKE_SOURCE_DIR}/package/DelAsyncHasher.app -qmldir=DelAsyncHasher
                COMMAND ${QT_DEPLOY_QT} ${CMAKE_SOURCE_DIR}/package/DelRate.app -qmldir=DelRate
                COMMAND ${QT_DEPLOY_QT} ${CMAKE_SOURCE_DIR}/package/DelSystemThemeHelper.app -qmldir=DelSystemThemeHelper
                COMMAND ${QT_DEPLOY_QT} ${CMAKE_SOURCE_DIR}/package/DelWatermark.app -qmldir=DelWatermark
                COMMAND ${QT_DEPLOY_QT} ${CMAKE_SOURCE_DIR}/package/DelTour.app -qmldir=DelTour
                COMMAND ${QT_DEPLOY_QT} ${CMAKE_SOURCE_DIR}/package/DelButton.app -qmldir=DelButton
                COMMAND ${QT_DEPLOY_QT} ${CMAKE_SOURCE_DIR}/package/DelDivider.app -qmldir=DelDivider
                COMMAND ${QT_DEPLOY_QT} ${CMAKE_SOURCE_DIR}/package/DelSwitch.app -qmldir=DelSwitch
                COMMAND ${QT_DEPLOY_QT} ${CMAKE_SOURCE_DIR}/package/DelAcrylic.app -qmldir=DelAcrylic
                COMMAND ${QT_DEPLOY_QT} ${CMAKE_SOURCE_DIR}/package/DelRoundRectangle.app -qmldir=DelRoundRectangle
                COMMAND ${QT_DEPLOY_QT} ${CMAKE_SOURCE_DIR}/package/DelTabView.app -qmldir=DelTabView
                COMMAND ${QT_DEPLOY_QT} ${CMAKE_SOURCE_DIR}/package/DelRadio.app -qmldir=DelRadio
                COMMAND ${QT_DEPLOY_QT} ${CMAKE_SOURCE_DIR}/package/DelRadioBlock.app -qmldir=DelRadioBlock
                COMMAND ${QT_DEPLOY_QT} ${CMAKE_SOURCE_DIR}/package/DelCheckBox.app -qmldir=DelCheckBox
                COMMAND ${QT_DEPLOY_QT} ${CMAKE_SOURCE_DIR}/package/DelInput.app -qmldir=DelInput
                COMMAND ${QT_DEPLOY_QT} ${CMAKE_SOURCE_DIR}/package/DelOTPInput.app -qmldir=DelOTPInput
                COMMAND ${QT_DEPLOY_QT} ${CMAKE_SOURCE_DIR}/package/DelSlider.app -qmldir=DelSlider
                COMMAND ${QT_DEPLOY_QT} ${CMAKE_SOURCE_DIR}/package/DelScrollBar.app -qmldir=DelScrollBar
                COMMAND ${QT_DEPLOY_QT} ${CMAKE_SOURCE_DIR}/package/DelTimePicker.app -qmldir=DelTimePicker
                COMMAND ${QT_DEPLOY_QT} ${CMAKE_SOURCE_DIR}/package/DelDrawer.app -qmldir=DelDrawer
                COMMAND ${QT_DEPLOY_QT} ${CMAKE_SOURCE_DIR}/package/DelCollapse.app -qmldir=DelCollapse
                COMMAND ${QT_DEPLOY_QT} ${CMAKE_SOURCE_DIR}/package/DelAvatar.app -qmldir=DelAvatar
                COMMAND ${QT_DEPLOY_QT} ${CMAKE_SOURCE_DIR}/package/DelCard.app -qmldir=DelCard
                COMMAND ${QT_DEPLOY_QT} ${CMAKE_SOURCE_DIR}/package/DelToolTip.app -qmldir=DelToolTip
                COMMAND ${QT_DEPLOY_QT} ${CMAKE_SOURCE_DIR}/package/DelPopup.app -qmldir=DelPopup
                COMMAND ${QT_DEPLOY_QT} ${CMAKE_SOURCE_DIR}/package/DelSelect.app -qmldir=DelSelect
                COMMAND ${QT_DEPLOY_QT} ${CMAKE_SOURCE_DIR}/package/DelPagination.app -qmldir=DelPagination
                COMMAND ${QT_DEPLOY_QT} ${CMAKE_SOURCE_DIR}/package/DelTimeline.app -qmldir=DelTimeline
                COMMAND ${QT_DEPLOY_QT} ${CMAKE_SOURCE_DIR}/package/DelTag.app -qmldir=DelTag
                COMMAND ${QT_DEPLOY_QT} ${CMAKE_SOURCE_DIR}/package/DelTableView.app -qmldir=DelTableView
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
                COMMAND ${QT_DEPLOY_QT} --qmldir=DelResizeMouseArea --no-translations --compiler-runtime ${CMAKE_SOURCE_DIR}/package/DelResizeMouseArea.exe
                COMMAND ${QT_DEPLOY_QT} --qmldir=DelAsyncHasher --no-translations --compiler-runtime ${CMAKE_SOURCE_DIR}/package/DelAsyncHasher.exe
                COMMAND ${QT_DEPLOY_QT} --qmldir=DelRate --no-translations --compiler-runtime ${CMAKE_SOURCE_DIR}/package/DelRate.exe
                COMMAND ${QT_DEPLOY_QT} --qmldir=DelSystemThemeHelper --no-translations --compiler-runtime ${CMAKE_SOURCE_DIR}/package/DelSystemThemeHelper.exe
                COMMAND ${QT_DEPLOY_QT} --qmldir=DelWatermark --no-translations --compiler-runtime ${CMAKE_SOURCE_DIR}/package/DelWatermark.exe
                COMMAND ${QT_DEPLOY_QT} --qmldir=DelTour --no-translations --compiler-runtime ${CMAKE_SOURCE_DIR}/package/DelTour.exe
                COMMAND ${QT_DEPLOY_QT} --qmldir=DelButton --no-translations --compiler-runtime ${CMAKE_SOURCE_DIR}/package/DelButton.exe
                COMMAND ${QT_DEPLOY_QT} --qmldir=DelDivider --no-translations --compiler-runtime ${CMAKE_SOURCE_DIR}/package/DelDivider.exe
                COMMAND ${QT_DEPLOY_QT} --qmldir=DelSwitch --no-translations --compiler-runtime ${CMAKE_SOURCE_DIR}/package/DelSwitch.exe
                COMMAND ${QT_DEPLOY_QT} --qmldir=DelAcrylic --no-translations --compiler-runtime ${CMAKE_SOURCE_DIR}/package/DelAcrylic.exe
                COMMAND ${QT_DEPLOY_QT} --qmldir=DelRoundRectangle --no-translations --compiler-runtime ${CMAKE_SOURCE_DIR}/package/DelRoundRectangle.exe
                COMMAND ${QT_DEPLOY_QT} --qmldir=DelTabView --no-translations --compiler-runtime ${CMAKE_SOURCE_DIR}/package/DelTabView.exe
                COMMAND ${QT_DEPLOY_QT} --qmldir=DelRadio --no-translations --compiler-runtime ${CMAKE_SOURCE_DIR}/package/DelRadio.exe
                COMMAND ${QT_DEPLOY_QT} --qmldir=DelRadioBlock --no-translations --compiler-runtime ${CMAKE_SOURCE_DIR}/package/DelRadioBlock.exe
                COMMAND ${QT_DEPLOY_QT} --qmldir=DelCheckBox --no-translations --compiler-runtime ${CMAKE_SOURCE_DIR}/package/DelCheckBox.exe
                COMMAND ${QT_DEPLOY_QT} --qmldir=DelInput --no-translations --compiler-runtime ${CMAKE_SOURCE_DIR}/package/DelInput.exe
                COMMAND ${QT_DEPLOY_QT} --qmldir=DelOTPInput --no-translations --compiler-runtime ${CMAKE_SOURCE_DIR}/package/DelOTPInput.exe
                COMMAND ${QT_DEPLOY_QT} --qmldir=DelSlider --no-translations --compiler-runtime ${CMAKE_SOURCE_DIR}/package/DelSlider.exe
                COMMAND ${QT_DEPLOY_QT} --qmldir=DelScrollBar --no-translations --compiler-runtime ${CMAKE_SOURCE_DIR}/package/DelScrollBar.exe
                COMMAND ${QT_DEPLOY_QT} --qmldir=DelTimePicker --no-translations --compiler-runtime ${CMAKE_SOURCE_DIR}/package/DelTimePicker.exe
                COMMAND ${QT_DEPLOY_QT} --qmldir=DelDrawer --no-translations --compiler-runtime ${CMAKE_SOURCE_DIR}/package/DelDrawer.exe
                COMMAND ${QT_DEPLOY_QT} --qmldir=DelCollapse --no-translations --compiler-runtime ${CMAKE_SOURCE_DIR}/package/DelCollapse.exe
                COMMAND ${QT_DEPLOY_QT} --qmldir=DelAvatar --no-translations --compiler-runtime ${CMAKE_SOURCE_DIR}/package/DelAvatar.exe
                COMMAND ${QT_DEPLOY_QT} --qmldir=DelCard --no-translations --compiler-runtime ${CMAKE_SOURCE_DIR}/package/DelCard.exe
                COMMAND ${QT_DEPLOY_QT} --qmldir=DelToolTip --no-translations --compiler-runtime ${CMAKE_SOURCE_DIR}/package/DelToolTip.exe
                COMMAND ${QT_DEPLOY_QT} --qmldir=DelPopup --no-translations --compiler-runtime ${CMAKE_SOURCE_DIR}/package/DelPopup.exe
                COMMAND ${QT_DEPLOY_QT} --qmldir=DelSelect --no-translations --compiler-runtime ${CMAKE_SOURCE_DIR}/package/DelSelect.exe
                COMMAND ${QT_DEPLOY_QT} --qmldir=DelPagination --no-translations --compiler-runtime ${CMAKE_SOURCE_DIR}/package/DelPagination.exe
                COMMAND ${QT_DEPLOY_QT} --qmldir=DelTimeline --no-translations --compiler-runtime ${CMAKE_SOURCE_DIR}/package/DelTimeline.exe
                COMMAND ${QT_DEPLOY_QT} --qmldir=DelTag --no-translations --compiler-runtime ${CMAKE_SOURCE_DIR}/package/DelTag.exe
                COMMAND ${QT_DEPLOY_QT} --qmldir=DelTableView --no-translations --compiler-runtime ${CMAKE_SOURCE_DIR}/package/DelTableView.exe
                COMMENT "Windows Deploying Qt Dependencies After Build........."
                SOURCES ${CMAKE_SOURCE_DIR}/CMakeLists.txt
                WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
        )
    endif()
endif()
