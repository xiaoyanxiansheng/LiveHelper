import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15

Window {
    id: window
    signal signalTest()
    signal clickdOpenWeChat()
    signal clickSearchLiveByName(string name)
    signal clickSendUserMsg(string msg)
    signal likeToggle(bool checked)
    signal likeTimeRefresh(int inverval)
    signal buyToggle(bool checked)
    signal buyTimeRefresh(int inverval)
    signal wellComeToggle(bool checked)
    signal wellComeReplayToggle(bool checked)
    signal wellComeReplayTimeRefresh(int inverval)
    signal screenToggle(bool checked)
    signal screenTimeRefresh(int inverval)
    signal helpToggle(bool checked)
    signal helpTimeRefresh(int inverval)
    signal danmuToggle(bool checked)

    function setLoginState(isLogin, namestr, iconPath){
        print(isLogin)
        print(namestr)
        login_item_login_none.visible = false
        login_item_login.visible = false
        if (isLogin === true) {
            login_item_login.visible = true
            login_item_login_icon.source = iconPath
            login_item_login_name.text = namestr
        } else {
            login_item_login_none.visible = true
        }
    }

    function setLiveInfo(name, icon, onlinecount, lookcount, likecount) {
        live_name.text = name
        live_icon.source = icon
        live_online_count.text = onlinecount
        live_look_count.text = lookcount
        live_like_count.text = likecount
    }

    function setDanmu(content) {
        danmu_content.text = content
    }

    function getScreenContent() {
        return screen_content.text
    }

    function getWellComeContent() {
        return wellcome.currentText
    }

    function setWellComeContentIndex(index) {
        wellcome.currentIndex = index
    }

    visible: true
    color: "#000000"
    width: 1620
    height: 932
    minimumWidth: 1620
    minimumHeight: 932
    title: "直播助手"
    flags: Qt.FramelessWindowHint


    Item {
        id: mainWindow
        anchors.top: customTitleBar.bottom
        width: parent.width
        height: 932

        Item {
            id: item1
            anchors.fill: parent
            anchors.rightMargin: -1
            anchors.leftMargin: -1
            anchors.bottomMargin: -1
            anchors.topMargin: -1

            Image {
                id: image
                x: -75
                y: -81
                width: 1771
                height: 1095
                horizontalAlignment: Image.AlignLeft
                verticalAlignment: Image.AlignBottom
                source: "content/images/矩形 11.png"
                fillMode: Image.Stretch
            }

            Rectangle {
                id: rectangle1
                x: 8
                y: 87
                width: 427
                height: 839
                color: "#fafafa"
                radius: 4
                border.color: "#c9c9c9"
                border.width: 0

                Label {
                    x: 18
                    y: 15
                    color: "#505050"
                    text: "用户登录"
                    font.pixelSize: 20
                    font.bold: true
                    font.family: "Arial"
                }

                Image {
                    id: image20
                    x: 0
                    y: 44
                    width: 418
                    height: 20
                    source: "images/矩形 7 拷贝 9.png"
                    fillMode: Image.PreserveAspectFit
                }

                Rectangle {
                    x: 8
                    y: 97
                    width: 402
                    height: 51
                    color: "#fafafafa"
                    //color: "#ffffff"
                    //border.color: "#7c7c7c"
                    radius: 10


                    Item {
                        id: login_item_login_none
                        x: -8
                        y: 139
                        width: 427
                        height: 51

                        Rectangle {
                            id: rectangle17
                            x: 52
                            y: 8
                            width: 321
                            height: 35
                            color: "#e1e1e1"
                            radius: 5
                            border.width: 0

                            MouseArea {
                                anchors.fill: parent
                                onClicked: clickdOpenWeChat()
                                onPressed: rectangle17.scale = 0.95
                                onReleased: rectangle17.scale = 1
                            }

                            Text {
                                id: text7
                                color: "#585858"
                                text: qsTr("登录")
                                anchors.fill: parent
                                font.pixelSize: 20
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                font.bold: true
                                font.family: "Arial"
                            }
                        }
                    }

                    Item {
                        id: login_item_login
                        x: 0
                        y: 0
                        width: 402
                        height: 51



                        Image {
                            id: image1
                            x: 3
                            y: 1
                            width: 50
                            height: 50
                            visible: true
                            source: "images/图层 1.png"
                            sourceSize.height: 100
                            sourceSize.width: 100
                            fillMode: Image.PreserveAspectFit
                        }
                        Image {
                            id: login_item_login_icon
                            x: 8
                            y: 5
                            source: "https://wx.qlogo.cn/mmhead/ver_1/WrwSUHOQKibIbHibiam2ymotIqt97ge0FHSGVMd6sLQX1yXsGbxx8Qt6mXibeUf9ulk4cWKOhThrYGHWLlaVkC0Jj4BUm0kolaeicKXhPteprhJ19JCvBx1DDXaq3N2JiadcrbmR3JZ5hY0sbF2HhxLZq0Ag/132" // 替换为实际头像路径
                            width: 40
                            height: 40
                            clip: true
                        }
                        Text {
                            id: login_item_login_name
                            x: 53
                            y: 7
                            width: 80
                            height: 38
                            color: "#505050"
                            text: "已登录"
                            font.pixelSize: 14
                            font.bold: true
                            font.family: "Arial"
                        }

                        Image {
                            id: image2
                            x: 33
                            y: 0
                            width: 20
                            height: 20
                            source: "images/图层 4.png"
                            fillMode: Image.PreserveAspectFit
                        }

                        ComboBox {
                            id: login_comboBox
                            x: 139
                            y: 9
                            width: 209
                            height: 32
                            editable: true
                            font.capitalization: Font.MixedCase
                            font.pointSize: 12
                            font.family: "Arial"
                            font.styleName: "Bold"
                            model: ["选项1", "选项2", "选项3"]

                            background: Rectangle {
                                width: login_comboBox.width
                                height: login_comboBox.height
                                color: "white"
                                border.color: "#ededed"
                                border.width: 1
                                radius: 4

                                Row {
                                    anchors.fill: parent
                                    spacing: 0
                                    padding: 0

                                    Rectangle {
                                        width: 0
                                        height: 0
                                        color: "transparent"
                                    }
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        login_comboBox.open()
                                    }
                                }
                            }

                            contentItem: TextField {
                                text: login_comboBox.currentText
                                font.pixelSize: 12
                                color: "#646464"
                                background: Rectangle {
                                    color: "transparent"
                                    border.color: "transparent"
                                    radius: 4
                                }
                                padding: 0
                                onTextChanged: {
                                    login_comboBox.currentText = text
                                }
                            }

                            indicator: Item {
                                width: 24
                                height: 24
                                anchors.right: parent.right
                                anchors.rightMargin: 5
                                Rectangle {
                                    width: parent.width
                                    height: parent.height
                                    color: "transparent"

                                    Image {
                                        source: "" // 替换为实际箭头图标路径
                                        anchors.centerIn: parent
                                        width: 10
                                        height: 10 // 设置箭头颜色
                                    }
                                }
                            }

                            Image {
                                id: image21
                                x: 0
                                y: 0
                                width: 209
                                height: 32
                                source: "images/图层 3.png"
                                fillMode: Image.Stretch
                            }
                        }


                        Image {
                            id: image19
                            x: 362
                            y: 9
                            width: 32
                            height: 32
                            source: "images/图层 2.png"
                            fillMode: Image.PreserveAspectFit

                            MouseArea {
                                anchors.fill: parent

                                onClicked: clickSendUserMsg(login_comboBox.currentText)
                                onPressed: image19.scale = 0.9
                                onReleased: image19.scale = 1
                            }
                        }

                        Image {
                            id: image17
                            y: 49
                            height: 2
                            anchors.left: parent.left
                            anchors.right: parent.right
                            source: "images/图层 11.png"
                            anchors.rightMargin: 0
                            anchors.leftMargin: 0
                            fillMode: Image.Stretch
                        }



                    }

                }
            }

            Rectangle {
                id: rectangle2
                x: 448
                y: 87
                width: 874
                height: 105
                color: "#fafafa"
                radius: 4
                border.width: 0

                Image {
                    id:live_icon
                    x: 18
                    y: 21
                    source: "images/矩形 12 拷贝 2.png" // 替换为实际用户头像路径
                    width: 62
                    height: 63
                    clip: true
                }

                Text {
                    id:live_name
                    x: 97
                    y: 25
                    color: "#111111"
                    text: "我的直播间"
                    font.pixelSize: 20
                }

                Text {
                    x: 97
                    y: 61
                    width: 34
                    height: 18
                    color: "#505050"
                    text: "在线："
                    font.pixelSize: 14
                }

                Text {
                    x: 191
                    y: 61
                    width: 34
                    height: 18
                    color: "#505050"
                    text: "看过："
                    font.pixelSize: 14
                }

                Text {
                    x: 285
                    y: 61
                    width: 36
                    height: 18
                    color: "#505050"
                    text: "点赞："
                    font.pixelSize: 14
                }

                TextField {
                    id: live_search_text
                    x: 545
                    y: 25
                    width: 251
                    height: 43
                    color: "#000000"
                    selectedTextColor: "#eef2fd"
                    font.pointSize: 8
                    selectionColor: "#eef2fd"
                    placeholderText: "请输入直播间名称"
                    background: Rectangle {
                        color: "#f5f6fa" // 更改为你想要的背景颜色
                        radius: 4
                    }
                }

                Image {
                    id: image3
                    x: 802
                    y: 13
                    width: 64
                    height: 66
                    source: "images/图层 4.png"
                    fillMode: Image.PreserveAspectFit

                    MouseArea {
                        anchors.fill: parent

                        onClicked: clickSearchLiveByName(live_search_text.text)
                        onPressed: image3.scale = 0.95
                        onReleased: image3.scale = 1
                    }
                }

                Text {
                    id: live_online_count
                    x: 130
                    y: 62
                    width: 55
                    height: 18
                    color: "#505050"
                    text: "16000"
                    font.pixelSize: 14
                }

                Text {
                    id: live_look_count
                    x: 224
                    y: 62
                    width: 55
                    height: 18
                    color: "#505050"
                    text: "16000"
                    font.pixelSize: 14
                }

                Text {
                    id: live_like_count
                    x: 319
                    y: 62
                    width: 36
                    height: 18
                    color: "#505050"
                    text: "16000"
                    font.pixelSize: 14
                }





            }

            Rectangle {
                id: rectangle3
                x: 448
                y: 210
                width: 430
                height: 182
                color: "#fafafa"
                radius: 4
                border.color: "#acacac"
                border.width: 0

                Text {
                    x: 14
                    y: 8
                    color: "#505050"
                    text: "自动欢迎"
                    font.pixelSize: 20
                    font.bold: true
                    font.family: "Arial"
                }

                Image {
                    id: image22
                    x: 0
                    y: 32
                    width: 430
                    height: 20
                    source: "images/矩形 7 拷贝 9.png"
                    fillMode: Image.PreserveAspectFit
                }

                Text {
                    x: 20
                    y: 129
                    color: "#505050"
                    text: "1 秒 / 间隔"
                    font.pixelSize: 14
                }

                ComboBox {
                    id: login_comboBox1
                    x: 20
                    y: 66
                    width: 258
                    height: 32
                    indicator: Item {
                        width: 24
                        height: 24
                        anchors.right: parent.right
                        anchors.rightMargin: 5
                        Rectangle {
                            width: parent.width
                            height: parent.height
                            color: "#00000000"
                            Image {
                                width: 10
                                height: 10
                                source: ""
                                anchors.centerIn: parent
                            }
                        }
                    }
                    editable: true
                    font.styleName: "Bold"
                    model: ["选项1", "选项2", "选项3"]
                    font.family: "Arial"

                    BorderImage {
                        id: borderImage
                        x: 0
                        y: 0
                        width: 258
                        height: 33
                        source: "images/图层 3.png"
                        border.bottom: 10
                        border.top: 10
                        border.right: 100
                        border.left: 10
                    }
                    font.pointSize: 12
                    contentItem: TextField {
                        color: "#646464"
                        text: login_comboBox1.currentText
                        font.pixelSize: 12
                        onTextChanged: {
                            login_comboBox1.currentText = text
                        }
                        padding: 0
                        background: Rectangle {
                            color: "#00000000"
                            radius: 4
                            border.color: "#00000000"
                        }
                    }
                    font.capitalization: Font.MixedCase
                    background: Rectangle {
                        width: login_comboBox1.width
                        height: login_comboBox1.height
                        color: "#ffffff"
                        radius: 4
                        border.color: "#ededed"
                        border.width: 1
                        Row {
                            anchors.fill: parent
                            spacing: 0
                            Rectangle {
                                width: 0
                                height: 0
                                color: "#00000000"
                            }
                            padding: 0
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                login_comboBox1.open()
                            }
                        }
                    }
                }

                CheckBox {
                    id: checkBox6
                    x: 318
                    y: 62
                    width: 120
                    text: qsTr("自动切换")
                    scale: 0.8
                    contentItem: Text {
                        x: 35
                        width: 60
                        color: checkBox6.checked ? "#4A90E2" : "#9E9E9E"
                        text: checkBox6.text
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        font.pixelSize: 16
                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignVCenter
                        anchors.leftMargin: 35
                        font.family: "Arial"
                        font.bold: true
                    }
                    onCheckedChanged: {
                        wellComeToggle(checked)
                    }
                }

                Rectangle {
                    id: rectangle18
                    x: 128
                    y: 125
                    width: 124
                    height: 24
                    color: "#fafafa"
                    radius: 4
                    border.color: "#ececec"

                    Text {
                        id: wellcometime
                        x: 30
                        y: 3
                        width: 58
                        height: 18
                        color: "#505050"
                        text: "4.5"
                        font.pixelSize: 14
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    Image {
                        id: image41
                        x: 0
                        y: 0
                        width: 24
                        height: 24
                        source: "images/图层 8.png"
                        fillMode: Image.PreserveAspectFit
                        MouseArea {
                            anchors.fill: parent

                            onClicked: screenTimeRefresh(wellcometime.text - 1)
                            onPressed: image41.scale = 0.95
                            onReleased: image41.scale = 1
                        }
                    }

                    Image {
                        id: image42
                        x: 100
                        y: 0
                        width: 24
                        height: 24
                        source: "images/图层 7.png"
                        fillMode: Image.PreserveAspectFit
                        MouseArea {
                            anchors.fill: parent
                            onClicked: screenTimeRefresh(wellcometime.text - 1)
                            onPressed: image42.scale = 0.95
                            onReleased: image42.scale = 1
                        }
                    }
                }

                CheckBox {
                    id: checkBox7
                    x: 318
                    y: 117
                    width: 120
                    text: qsTr("自动欢迎")
                    scale: 0.8
                    contentItem: Text {
                        x: 35
                        width: 60
                        color: checkBox7.checked ? "#4A90E2" : "#9E9E9E"
                        text: checkBox7.text
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        font.pixelSize: 16
                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignVCenter
                        anchors.leftMargin: 35
                        font.family: "Arial"
                        font.bold: true
                    }
                    onCheckedChanged: {
                        wellComeReplayToggle(checked)
                    }
                }














            }

            Rectangle {
                id: rectangle4
                x: 448
                y: 411
                width: 430
                height: 515
                color: "#fafafa"
                radius: 4
                border.color: "#cfcfcf"
                border.width: 0

                Rectangle {
                    id: rectangle8
                    x: 0
                    y: 89
                    width: 430
                    height: 426
                    color: "#fafafa"
                    radius: 4
                    border.color: "lightgray"
                    border.width: 0
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    anchors.rightMargin: 0
                    anchors.bottomMargin: 0


                    Rectangle {
                        id: rectangle
                        x: 0
                        y: 0
                        width: 102
                        height: 426
                        color: "#fafafa"

                        Rectangle {
                            id: rectangle9
                            x: 0
                            y: 3
                            width: 102
                            height: 30
                            color: "#deebf9"

                            Text {
                                id: text1
                                color: "#505050"
                                text: qsTr("公屏1")
                                anchors.verticalCenter: parent.verticalCenter
                                font.pixelSize: 12
                                anchors.horizontalCenter: parent.horizontalCenter
                            }

                            Image {
                                id: image7
                                x: 0
                                y: 29
                                width: 102
                                height: 1
                                source: "images/图层 11.png"
                                fillMode: Image.PreserveAspectFit
                            }
                        }

                        Rectangle {
                            id: rectangle10
                            x: 0
                            y: 34
                            width: 102
                            height: 30
                            color: "#fafafa"
                            Text {
                                id: text2
                                color: "#505050"
                                text: qsTr("公屏2")
                                anchors.verticalCenter: parent.verticalCenter
                                font.pixelSize: 12
                                anchors.horizontalCenter: parent.horizontalCenter
                            }

                            Image {
                                id: image8
                                x: 0
                                y: 29
                                width: 102
                                height: 1
                                source: "images/图层 11.png"
                                fillMode: Image.PreserveAspectFit
                            }
                        }

                        Rectangle {
                            id: rectangle11
                            x: 0
                            y: 65
                            width: 102
                            height: 30
                            color: "#fafafa"
                            Text {
                                id: text3
                                color: "#505050"
                                text: qsTr("公屏3")
                                anchors.verticalCenter: parent.verticalCenter
                                font.pixelSize: 12
                                anchors.horizontalCenter: parent.horizontalCenter
                            }

                            Image {
                                id: image9
                                x: 0
                                y: 29
                                width: 102
                                height: 1
                                source: "images/图层 11.png"
                                fillMode: Image.PreserveAspectFit
                            }
                        }
                    }

                    Rectangle {
                        id: rectangle23
                        x: 108
                        y: 0
                        width: 322
                        height: 426
                        color: "#fafafa"
                        radius: 4
                        border.color: "#ebebeb"
                        border.width: 1

                        TextInput {
                            id: screen_content
                            x: 8
                            y: 8
                            width: 306
                            height: 410
                            color: "#505050"
                            text: qsTr("111")
                            font.pixelSize: 12
                        }
                    }
                }

                Text {
                    x: 14
                    y: 8
                    color: "#505050"
                    text: "互助发言"
                    font.pixelSize: 20
                }

                Image {
                    id: image24
                    x: 0
                    y: 33
                    width: 430
                    height: 20
                    source: "images/矩形 7 拷贝 9.png"
                    fillMode: Image.PreserveAspectFit
                }

                Text {
                    x: 20
                    y: 59
                    color: "#505050"
                    text: "1 秒 / 间隔"
                    font.pixelSize: 14
                }

                CheckBox {
                    id: checkBox8
                    x: 322
                    y: 47
                    width: 120
                    text: qsTr("自动发言")
                    scale: 0.8
                    contentItem: Text {
                        x: 35
                        width: 60
                        color: checkBox8.checked ? "#4A90E2" : "#9E9E9E"
                        text: checkBox8.text
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        font.pixelSize: 16
                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignVCenter
                        anchors.leftMargin: 35
                        font.family: "Arial"
                        font.bold: true
                    }
                    onCheckedChanged: {
                        helpToggle(chekced)
                    }
                }

                Rectangle {
                    id: rectangle19
                    x: 128
                    y: 55
                    width: 124
                    height: 24
                    color: "#fafafa"
                    radius: 4
                    border.color: "#ececec"
                    Text {
                        id: wellcometime1
                        x: 30
                        y: 3
                        width: 58
                        height: 18
                        color: "#505050"
                        text: "4.5"
                        font.pixelSize: 14
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    Image {
                        id: image43
                        x: 0
                        y: 0
                        width: 24
                        height: 24
                        source: "images/图层 8.png"
                        fillMode: Image.PreserveAspectFit
                        MouseArea {
                            anchors.fill: parent
                            onClicked: screenTimeRefresh(wellcometime1.text - 1)
                            onPressed: image43.scale = 0.95
                            onReleased: image43.scale = 1
                        }
                    }

                    Image {
                        id: image44
                        x: 100
                        y: 0
                        width: 24
                        height: 24
                        source: "images/图层 7.png"
                        fillMode: Image.PreserveAspectFit
                        MouseArea {
                            anchors.fill: parent
                            onClicked: screenTimeRefresh(wellcometime1.text - 1)
                            onPressed: image44.scale = 0.95
                            onReleased: image44.scale = 1
                        }
                    }
                }









            }

            Rectangle {
                id: rectangle7
                x: 1335
                y: 94
                width: 279
                height: 832
                color: "#fafafa"
                radius: 4
                border.color: "#d4d4d4"
                border.width: 0

                Text {
                    x: 18
                    y: 13
                    color: "#505050"
                    text: "实时弹幕"
                    font.pixelSize: 20
                    font.family: "Arial"
                    font.bold: true
                }

                //            ScrollView {
                //                anchors.fill: parent
                //                anchors.topMargin: 45

                //                Text {
                //                    id:danmu_content
                //                    x: 8
                //                    y: -97
                //                    width: 261
                //                    height: 938
                //                    text: "aaa"
                //                    elide: Text.ElideNone
                //                    font.pixelSize: 14
                //                    verticalAlignment: Text.AlignTop
                //                    lineHeight: 2
                //                    padding: 1
                //                    font.strikeout: false
                //                }
                //            }

                Image {
                    id: image27
                    x: 0
                    y: 36
                    width: 277
                    height: 20
                    source: "images/矩形 7 拷贝 9.png"
                    fillMode: Image.PreserveAspectFit
                }

                ScrollView {
                    x: 8
                    y: 56
                    width: 263
                    height: 768
                    contentWidth: 0
                    //width: parent.width
                    //height: parent.height
                    clip: true

                    Text {
                        id: danmu_content
                        x: 0
                        y: 0
                        width: 263
                        height: 1311
                        text: ""
                        wrapMode: Text.WordWrap
                        textFormat: Text.RichText
                        font.pixelSize: 16

                        //                    MouseArea {
                        //                        id: dragArea
                        //                        anchors.fill: parent
                        //                        drag.target: danmu_content
                        //                        drag.axis: Drag.YAxis

                        //                        onReleased: {
                        //                            // 检测边缘
                        //                            if (danmu_content.y > 0) {
                        //                                danmu_content.y = 0
                        //                            } else if (scrollableText.y < -(danmu_content.height - parent.height)) {
                        //                                danmu_content.y = -(danmu_content.height - parent.height)
                        //                            }
                        //                        }
                        //                    }
                    }
                }

                Switch {
                    id: customSwitch1
                    x: 224
                    y: 12
                    width: 47
                    height: 26
                    text: "\u5f00"
                    onCheckedChanged: {
                        danmuToggle(checked)
                    }
                    background: Rectangle {
                        color: customSwitch1.checked ? "#D0E7FF" : "#E0E0E0"
                        radius: 15
                        border.color: "#bdbdbd"
                        border.width: 0
                        implicitWidth: 60
                        implicitHeight: 30
                    }
                    indicator: Rectangle {
                        x: customSwitch1.checked ? parent.width - width - 1 : 1
                        y: 1
                        width: 24
                        height: 24
                        color: customSwitch1.checked ? "#4A90E2" : "white"
                        radius: 15
                        border.color: "#bdbdbd"
                        border.width: 0
                    }
                    contentItem: Text {
                        x: 6
                        color: "#afafaf"
                        text: customSwitch1.checked ? "开" : "关"
                        anchors.verticalCenter: parent.verticalCenter
                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignVCenter
                        font.family: "Arial"
                        font.bold: true
                        font.pointSize: 8
                        anchors.leftMargin: 10
                    }
                }

            }

            Rectangle {
                id: rectangle12
                x: 891
                y: 210
                width: 431
                height: 182
                color: "#fafafa"
                radius: 4
                border.color: "#acacac"
                border.width: 0

                Text {
                    x: 20
                    y: 8
                    color: "#505050"
                    text: "自动功能"
                    font.pixelSize: 20
                    font.bold: true
                    font.family: "Arial"
                }

                Image {
                    id: image26
                    x: 1
                    y: 32
                    width: 430
                    height: 20
                    source: "images/矩形 7 拷贝 9.png"
                    fillMode: Image.PreserveAspectFit
                }

                Text {
                    x: 20
                    y: 129
                    color: "#505050"
                    text: "1 秒 / 间隔"
                    font.pixelSize: 14
                }

                Rectangle {
                    id: rectangle20
                    x: 154
                    y: 66
                    width: 124
                    height: 24
                    color: "#fafafa"
                    radius: 4
                    border.color: "#ececec"
                    Text {
                        id: wellcometime3
                        x: 30
                        y: 3
                        width: 58
                        height: 18
                        color: "#505050"
                        text: "4.5"
                        font.pixelSize: 14
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    Image {
                        id: image47
                        x: 0
                        y: 0
                        width: 24
                        height: 24
                        source: "images/图层 8.png"
                        fillMode: Image.PreserveAspectFit
                        MouseArea {
                            anchors.fill: parent
                            onClicked: screenTimeRefresh(wellcometime3.text - 1)
                            onPressed: image47.scale = 0.95
                            onReleased: image47.scale = 1
                        }
                    }

                    Image {
                        id: image48
                        x: 100
                        y: 0
                        width: 24
                        height: 24
                        source: "images/图层 7.png"
                        fillMode: Image.PreserveAspectFit
                        MouseArea {
                            anchors.fill: parent
                            onClicked: screenTimeRefresh(wellcometime3.text - 1)
                            onPressed: image48.scale = 0.95
                            onReleased: image48.scale = 1
                        }
                    }
                }

                CheckBox {
                    id: checkBox3
                    x: 307
                    y: 58
                    width: 120
                    text: qsTr("自动点赞")
                    scale: 0.8
                    onCheckedChanged: {
                        likeToggle(checked)
                    }
                    contentItem: Text {
                        x: 35
                        width: 60
                        text: checkBox3.text
                        anchors.verticalCenter: parent.verticalCenter
                        color: checkBox3.checked ? "#4A90E2" : "#9E9E9E"
                        font.pixelSize: 16
                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignVCenter
                        anchors.leftMargin: 35
                        font.bold: true
                        font.family: "Arial"
                        anchors.left: parent.left
                    }
                }

                Text {
                    x: 20
                    y: 70
                    color: "#505050"
                    text: "1 秒 / 间隔"
                    font.pixelSize: 14
                }

                Rectangle {
                    id: rectangle22
                    x: 154
                    y: 125
                    width: 124
                    height: 24
                    color: "#fafafa"
                    radius: 4
                    border.color: "#ececec"
                    Text {
                        id: wellcometime4
                        x: 30
                        y: 3
                        width: 58
                        height: 18
                        color: "#505050"
                        text: "4.5"
                        font.pixelSize: 14
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    Image {
                        id: image49
                        x: 0
                        y: 0
                        width: 24
                        height: 24
                        source: "images/图层 8.png"
                        fillMode: Image.PreserveAspectFit
                        MouseArea {
                            anchors.fill: parent
                            onClicked: screenTimeRefresh(wellcometime4.text - 1)
                            onPressed: image49.scale = 0.95
                            onReleased: image49.scale = 1
                        }
                    }

                    Image {
                        id: image50
                        x: 100
                        y: 0
                        width: 24
                        height: 24
                        source: "images/图层 7.png"
                        fillMode: Image.PreserveAspectFit
                        MouseArea {
                            anchors.fill: parent
                            onClicked: screenTimeRefresh(wellcometime4.text - 1)
                            onPressed: image50.scale = 0.95
                            onReleased: image50.scale = 1
                        }
                    }
                }

                CheckBox {
                    id: checkBox4
                    x: 307
                    y: 117
                    width: 120
                    text: qsTr("自动购买")
                    scale: 0.8
                    contentItem: Text {
                        x: 35
                        width: 60
                        color: checkBox4.checked ? "#4A90E2" : "#9E9E9E"
                        text: checkBox4.text
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        font.pixelSize: 16
                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignVCenter
                        anchors.leftMargin: 35
                        font.family: "Arial"
                        font.bold: true
                    }
                    onCheckedChanged: {
                        buyToggle(checked)
                    }
                }


            }

            Rectangle {
                id: rectangle5
                x: 891
                y: 411
                width: 430
                height: 515
                color: "#fafafa"
                radius: 4
                border.color: "#cfcfcf"
                border.width: 0
                Rectangle {
                    id: rectangle16
                    x: 0
                    y: 89
                    width: 430
                    height: 426
                    color: "#fafafa"
                    radius: 4
                    border.color: "#d3d3d3"
                    border.width: 0
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    anchors.rightMargin: 0
                    anchors.bottomMargin: 0
                    Rectangle {
                        id: rectangle6
                        x: 0
                        y: 0
                        width: 102
                        height: 426
                        color: "#fafafa"
                        Rectangle {
                            id: rectangle13
                            x: 0
                            y: 3
                            width: 102
                            height: 30
                            color: "#fafafa"
                            Text {
                                id: text4
                                color: "#505050"
                                text: qsTr("公屏1")
                                anchors.verticalCenter: parent.verticalCenter
                                font.pixelSize: 12
                                anchors.horizontalCenter: parent.horizontalCenter
                            }

                            Image {
                                id: image14
                                x: 0
                                y: 29
                                width: 102
                                height: 1
                                source: "images/图层 11.png"
                                fillMode: Image.PreserveAspectFit
                            }
                        }

                        Rectangle {
                            id: rectangle14
                            x: 0
                            y: 34
                            width: 102
                            height: 30
                            color: "#fafafa"
                            Text {
                                id: text5
                                color: "#505050"
                                text: qsTr("公屏2")
                                anchors.verticalCenter: parent.verticalCenter
                                font.pixelSize: 12
                                anchors.horizontalCenter: parent.horizontalCenter
                            }

                            Image {
                                id: image15
                                x: 0
                                y: 29
                                width: 102
                                height: 1
                                source: "images/图层 11.png"
                                fillMode: Image.PreserveAspectFit
                            }
                        }

                        Rectangle {
                            id: rectangle15
                            x: 0
                            y: 65
                            width: 102
                            height: 30
                            color: "#fafafa"
                            Text {
                                id: text6
                                color: "#505050"
                                text: qsTr("公屏3")
                                anchors.verticalCenter: parent.verticalCenter
                                font.pixelSize: 12
                                anchors.horizontalCenter: parent.horizontalCenter
                            }

                            Image {
                                id: image16
                                x: 0
                                y: 29
                                width: 102
                                height: 1
                                source: "images/图层 11.png"
                                fillMode: Image.PreserveAspectFit
                            }
                        }
                    }

                    Rectangle {
                        id: rectangle24
                        x: 100
                        y: 0
                        width: 322
                        height: 426
                        color: "#fafafa"
                        radius: 4
                        border.color: "#ebebeb"
                        border.width: 1
                        TextInput {
                            id: screen_content2
                            x: 8
                            y: 8
                            width: 306
                            height: 410
                            color: "#505050"
                            text: qsTr("111")
                            font.pixelSize: 12
                        }
                    }

                }

                Text {
                    x: 14
                    y: 8
                    color: "#505050"
                    text: "屏幕发言"
                    font.pixelSize: 20
                }

                Image {
                    id: image25
                    x: 0
                    y: 33
                    width: 430
                    height: 20
                    source: "images/矩形 7 拷贝 9.png"
                    fillMode: Image.PreserveAspectFit
                }

                Text {
                    x: 20
                    y: 59
                    color: "#505050"
                    text: "1 秒 / 间隔"
                    font.pixelSize: 14
                }

                CheckBox {
                    id: checkBox5
                    x: 308
                    y: 47
                    width: 120
                    text: qsTr("开启飘屏")
                    scale: 0.8
                    contentItem: Text {
                        x: 35
                        width: 60
                        color: checkBox5.checked ? "#4A90E2" : "#9E9E9E"
                        text: checkBox5.text
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        font.pixelSize: 16
                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignVCenter
                        anchors.leftMargin: 35
                        font.family: "Arial"
                        font.bold: true
                    }
                    onCheckedChanged: {
                        screenToggle(checked)
                    }
                }

                Rectangle {
                    id: rectangle21
                    x: 128
                    y: 55
                    width: 124
                    height: 24
                    color: "#fafafa"
                    radius: 4
                    border.color: "#ececec"
                    Text {
                        id: wellcometime2
                        x: 30
                        y: 3
                        width: 58
                        height: 18
                        color: "#505050"
                        text: "4.5"
                        font.pixelSize: 14
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    Image {
                        id: image45
                        x: 0
                        y: 0
                        width: 24
                        height: 24
                        source: "images/图层 8.png"
                        fillMode: Image.PreserveAspectFit
                        MouseArea {
                            anchors.fill: parent
                            onClicked: screenTimeRefresh(wellcometime2.text - 1)
                            onPressed: image45.scale = 0.95
                            onReleased: image45.scale = 1
                        }
                    }

                    Image {
                        id: image46
                        x: 100
                        y: 0
                        width: 24
                        height: 24
                        source: "images/图层 7.png"
                        fillMode: Image.PreserveAspectFit
                        MouseArea {
                            anchors.fill: parent
                            onClicked: screenTimeRefresh(wellcometime2.text - 1)
                            onPressed: image46.scale = 0.95
                            onReleased: image46.scale = 1
                        }
                    }
                }




            }

        }

        Rectangle {
            id: customTitleBar
            width: 1568
            height: 70
            color: "#fafafa"
            radius: 5
            border.color: "gray"
            border.width: 0
            anchors.verticalCenter: parent.verticalCenter
            anchors.top: parent.top
            anchors.verticalCenterOffset: -431
            anchors.horizontalCenterOffset: 26
            anchors.topMargin: 0
            anchors.horizontalCenter: parent.horizontalCenter

            MouseArea {
                id: titleBarMouseArea
                anchors.fill: parent
                anchors.leftMargin: 22
                onPressed: {
                    window.startSystemMove(titleBarMouseArea.mouseX, titleBarMouseArea.mouseY)
                }
            }

            Text {
                x: 10
                y: 26
                width: 123
                height: 27
                color: "#afafaf"
                text: "天书小助手"
                verticalAlignment: Text.AlignVCenter
                font.bold: true
                font.pointSize: 12
                font.family: "Arial"
                horizontalAlignment: Text.AlignLeft
                anchors.left: parent.left
                anchors.leftMargin: 22
            }

            Image {
                id: image222
                x: 1432
                y: 23
                width: 30
                height: 30
                source: "images/矩形 12 拷贝 2.png"
                fillMode: Image.PreserveAspectFit

                MouseArea {
                    anchors.fill: parent
                    onClicked: window.showMinimized()
                }
            }

            Image {
                id: image111
                x: 1488
                y: 23
                width: 30
                height: 30
                source: "images/图层 12.png"
                fillMode: Image.PreserveAspectFit
                MouseArea {
                    anchors.fill: parent
                    onClicked: Qt.quit()
                }
            }



        }
    }



}


