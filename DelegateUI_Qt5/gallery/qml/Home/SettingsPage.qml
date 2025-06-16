import QtQuick 2.15
import QtQuick.Layouts 1.15 
import QtGraphicalEffects 1.15
import QtQuick.Controls 2.15
import DelegateUI 1.0

import '../Controls'

DelWindow {
    id: root
    width: 400
    height: 500
    minimumWidth: 400
    minimumHeight: 500
    captionBar.minimizeButtonVisible: false
    captionBar.maximizeButtonVisible: false
    captionBar.winTitle: qsTr('设置')
    captionBar.winIconDelegate: Item {
        DelIconText {
            iconSize: 22
            colorIcon: '#C44545'
            font.bold: true
            iconSource: DelIcon.DelegateUIPath1
        }
        DelIconText {
            iconSize: 22
            colorIcon: '#C44545'
            font.bold: true
            iconSource: DelIcon.DelegateUIPath2
        }
    }
    captionBar.closeCallback: () => settingsLoader.visible = false;

    Item {
        anchors.fill: parent

        DropShadow {
            anchors.fill: backRect
            radius: 8.0
            samples: 17
            color: DelTheme.Primary.colorTextBase
            source: backRect
        }

        Rectangle {
            id: backRect
            anchors.fill: parent
            radius: 6
            color: DelTheme.Primary.colorBgBase
            border.color: DelThemeFunctions.alpha(DelTheme.Primary.colorTextBase, 0.2)
        }

        Item {
            anchors.fill: parent

            ShaderEffect {
                anchors.fill: parent
                vertexShader: 'qrc:/Gallery/shaders/effect2.vert'
                fragmentShader: 'qrc:/Gallery/shaders/effect2.frag'
                opacity: 0.5

                property vector3d iResolution: Qt.vector3d(width, height, 0)
                property real iTime: 0

                Timer {
                    running: true
                    repeat: true
                    interval: 10
                    onTriggered: parent.iTime += 0.03;
                }
            }
        }

        Column {
            width: parent.width
            anchors.top: parent.top
            anchors.topMargin: captionBar.height + 20
            spacing: 20

            MySlider {
                id: themeSpeed
                label.text: qsTr('动画基础速度')
                slider.min: 20
                slider.max: 200
                slider.stepSize: 1
                slider.onFirstReleased: {
                    const base = slider.currentValue;
                    DelTheme.installThemePrimaryAnimationBase(base, base * 2, base * 3);
                }
                slider.handleToolTipDelegate: DelToolTip {
                    arrowVisible: true
                    delay: 100
                    text: themeSpeed.slider.currentValue
                    visible: handlePressed || handleHovered
                }
                Component.onCompleted: {
                    slider.value = DelTheme.Primary.durationFast;
                }
            }

            MySlider {
                id: bgOpacitySlider
                label.text: qsTr('背景透明度')
                slider.value: galleryBackground.opacity
                slider.snapMode: DelSlider.SnapOnRelease
                slider.onFirstMoved: {
                    galleryBackground.opacity = slider.currentValue;
                }
                slider.handleToolTipDelegate: DelToolTip {
                    arrowVisible: true
                    delay: 100
                    text: bgOpacitySlider.slider.currentValue.toFixed(1)
                    visible: handlePressed || handleHovered
                }
            }

            MySlider {
                label.text: qsTr('字体大小')
                slider.min: 12
                slider.max: 24
                slider.stepSize: 4
                slider.value: DelTheme.Primary.fontPrimarySizeHeading5
                slider.snapMode: DelSlider.SnapAlways
                slider.onFirstReleased: {
                    DelTheme.installThemePrimaryFontSizeBase(slider.currentValue);
                }
                scaleVisible: true
            }

            Row {
                anchors.left: parent.left
                anchors.leftMargin: 30
                spacing: 20

                Text {
                    width: DelTheme.Primary.fontPrimarySize * 5
                    anchors.verticalCenter: parent.verticalCenter
                    text: qsTr('应用主题')
                    font {
                        family: DelTheme.Primary.fontPrimaryFamily
                        pixelSize: DelTheme.Primary.fontPrimarySize
                    }
                    color: DelTheme.Primary.colorTextBase
                }

                DelSelect {
                    id: darkModeSelect
                    width: 110
                    anchors.verticalCenter: parent.verticalCenter
                    currentIndex: 0
                    model: [
                        { 'label': qsTr('浅色'), 'value': DelTheme.Light },
                        { 'label': qsTr('深色'), 'value': DelTheme.Dark },
                        { 'label': qsTr('跟随系统'), 'value': DelTheme.System }
                    ]
                    onActivated: {
                        DelTheme.darkMode = currentValue;
                    }

                    Connections {
                        target: DelTheme
                        function onDarkModeChanged() {
                            darkModeSelect.currentIndex = DelTheme.darkMode;
                        }
                    }
                }
            }

            Row {
                anchors.left: parent.left
                anchors.leftMargin: 30
                spacing: 20

                Text {
                    width: DelTheme.Primary.fontPrimarySize * 5
                    anchors.verticalCenter: parent.verticalCenter
                    text: qsTr('窗口效果')
                    font {
                        family: DelTheme.Primary.fontPrimaryFamily
                        pixelSize: DelTheme.Primary.fontPrimarySize
                    }
                    color: DelTheme.Primary.colorTextBase
                }

                DelSelect {
                    id: effectSelect
                    width: 110
                    anchors.verticalCenter: parent.verticalCenter
                    currentIndex: 0
                    model: [
                        { 'label': qsTr('浅色'), 'value': DelTheme.Light },
                        { 'label': qsTr('深色'), 'value': DelTheme.Dark },
                        { 'label': qsTr('跟随系统'), 'value': DelTheme.System }
                    ]
                    onActivated: {
                        galleryWindow.setSpecialEffect(currentValue);
                    }
                    Component.onCompleted: {
                        if (Qt.platform.os === 'windows'){
                            model = [
                                        { 'label': qsTr('无'), 'value': DelWindow.None },
                                        { 'label': qsTr('模糊'), 'value': DelWindow.Win_DwmBlur },
                                        { 'label': qsTr('亚克力'), 'value': DelWindow.Win_AcrylicMaterial },
                                        { 'label': qsTr('云母'), 'value': DelWindow.Win_Mica },
                                        { 'label': qsTr('云母变体'), 'value': DelWindow.Win_MicaAlt }
                                    ];
                        } else if (Qt.platform.os === 'osx') {
                            model = [
                                        { 'label': qsTr('无'), 'value': DelWindow.None },
                                        { 'label': qsTr('模糊'), 'value': DelWindow.Mac_BlurEffect },
                                    ];
                        }
                    }

                    Connections {
                        target: galleryWindow
                        function onSpecialEffectChanged() {
                            effectSelect.currentIndex = effectSelect.indexOfValue(galleryWindow.specialEffect);
                        }
                    }
                }
            }

            Row {
                anchors.left: parent.left
                anchors.leftMargin: 30
                spacing: 20

                Text {
                    width: DelTheme.Primary.fontPrimarySize * 5
                    anchors.verticalCenter: parent.verticalCenter
                    text: qsTr('导航模式')
                    font {
                        family: DelTheme.Primary.fontPrimaryFamily
                        pixelSize: DelTheme.Primary.fontPrimarySize
                    }
                    color: DelTheme.Primary.colorTextBase
                }

                DelRadioBlock {
                    id: navMode
                    initCheckedIndex: 0
                    model: [
                        { label: '默认', value: false },
                        { label: '紧凑', value: true }
                    ]
                    onClicked:
                        (index, radioData) => {
                            galleryMenu.compactMode = radioData.value;
                        }

                    Connections {
                        target: galleryMenu
                        function onCompactModeChanged() {
                            navMode.currentCheckedIndex = galleryMenu.compactMode ? 1 : 0;
                        }
                    }
                }
            }
        }
    }
}
