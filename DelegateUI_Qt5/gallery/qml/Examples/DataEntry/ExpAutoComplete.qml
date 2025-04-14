import QtQuick 2.15
import QtQuick.Layouts 1.15 
import QtQuick.Controls 2.15
import DelegateUI 1.0

import "../../Controls"

Flickable {
    contentHeight: column.height
    ScrollBar.vertical: DelScrollBar { }

    Column {
        id: column
        width: parent.width - 15
        spacing: 30

        Description {
            desc: qsTr(`
## DelAutoComplete 自动完成 \n
输入或选择时间的控件。\n
* **继承自 { TextField }**\n
支持的代理：\n
- 无\n
支持的属性：\n
属性名 | 类型 | 描述
------ | --- | ---
animationEnabled | bool | 是否开启动画(默认true)
active(readonly) | bool | 是否处于激活状态
format | enum | 时间格式(来自 DelTimePicker)
iconSize | int | 图标大小
iconPosition | enum | 图标位置(来自 DelTimePicker)
colorText | color | 输入框文本颜色
colorBorder | color | 输入框边框颜色
colorBg | color | 输入框背景颜色
colorPopupText | color | 弹出框背景颜色
popupFont | font | 弹出框字体
radiusBg | int | 输入框背景半径
radiusPopupBg | int | 弹出框背景半径
contentDescription | string | 内容描述(提高可用性)
\n支持的函数：\n
- \`clearTime()\` 清空时间 \n
\n支持的信号：\n
- \`acceptedTime(time: string)\` 接受时间时发出\n
                       `)
        }

        Description {
            title: qsTr("何时使用")
            desc: qsTr(`
- 需要一个输入框而不是选择器。\n
- 需要输入建议/辅助提示。\n
和 [DelSelect](internal://DelSelect) 的区别是：\n
- [DelAutoComplete](internal://DelAutoComplete) 是一个带提示的文本输入框，用户可以自由输入，关键词是**辅助输入**。\n
- [DelSelect](internal://DelSelect) 是在限定的可选项中进行选择，关键词是**选择**。\n
                       `)
        }

        Description {
            title: qsTr("代码演示")
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('基本使用')
            desc: qsTr(`
基本使用，通过 \`options\` 设置自动完成的数据源。\n
                       `)
            code: `
                import QtQuick 2.15
                import DelegateUI 1.0

                Row {
                    spacing: 10

                    DelAutoComplete {
                        width: 180
                        placeholderText: qsTr('input here')
                        onSearch: function(input) {
                            options = input ? [{ label: input.repeat(1) }, { label: input.repeat(2) }, { label: input.repeat(3) }] : [];
                        }
                    }
                }
            `
            exampleDelegate: Row {
                spacing: 10

                DelAutoComplete {
                    width: 180
                    placeholderText: qsTr('input here')
                    onSearch: function(input) {
                        options = input ? [{ label: input.repeat(1) }, { label: input.repeat(2) }, { label: input.repeat(3) }] : [];
                    }
                }
            }
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('自定义选项')
            desc: qsTr(`
可以返回自定义的 \`options\` 的 label。\n
                       `)
            code: `
                import QtQuick 2.15
                import DelegateUI 1.0

                Row {
                    spacing: 10

                    DelAutoComplete {
                        width: 180
                        placeholderText: qsTr('input here')
                        onSearch: function(input) {
                            if (!input || input.includes('@')) {
                                options = [];
                            } else {
                                options = ['gmail.com', '163.com', 'qq.com'].map(
                                            (domain) => ({
                                                             label: \`\${input}@\${domain}\`,
                                                             value: \`\${input}@\${domain}\`,
                                                         }));
                            }
                        }
                    }
                }
            `
            exampleDelegate: Row {
                spacing: 10

                DelAutoComplete {
                    width: 180
                    placeholderText: qsTr('input here')
                    onSearch: function(input) {
                        if (!input || input.includes('@')) {
                            options = [];
                        } else {
                            options = ['gmail.com', '163.com', 'qq.com'].map(
                                        (domain) => ({
                                                         label: `${input}@${domain}`,
                                                         value: `${input}@${domain}`,
                                                     }));
                        }
                    }
                }
            }
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr('不区分大小写')
            desc: qsTr(`
不区分大小写的 DelAutoComplete。\n
通过 \`filterOption\` 设置过滤选项，它是形如：\`function(input: string, option: var): bool { }\` 的函数。\n
                       `)
            code: `
                import QtQuick 2.15
                import DelegateUI 1.0

                Row {
                    spacing: 10

                    DelAutoComplete {
                        width: 180
                        placeholderText: qsTr('try to type \`b\`')
                        options: [
                            { label: 'Burns Bay Road' },
                            { label: 'Downing Street' },
                            { label: 'Wall Street' },
                        ]
                        filterOption: (input, option) => option.label.toUpperCase().indexOf(input.toUpperCase()) !== -1
                    }
                }
            `
            exampleDelegate: Row {
                spacing: 10

                DelAutoComplete {
                    width: 180
                    placeholderText: qsTr('try to type `b`')
                    options: [
                        { label: 'Burns Bay Road' },
                        { label: 'Downing Street' },
                        { label: 'Wall Street' },
                    ]
                    filterOption: (input, option) => option.label.toUpperCase().indexOf(input.toUpperCase()) !== -1
                }
            }
        }
    }
}
