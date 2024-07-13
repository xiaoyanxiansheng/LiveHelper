import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
//import Qt5Compat.GraphicalEffects 1.0
import Qt.labs.platform 1.1

Window {
    id: window


    property int screenSelectIndex: 0

    signal quitApplication()
    signal signalTest()
    signal clickdOpenWeChat()
    signal clickSearchLiveByName(string name)
    signal clickSendUserMsg(int index ,string msg)
    signal likeToggle(bool checked)
    signal likeTimeRefresh()
    signal buyToggle(bool checked)
    signal buyTimeRefresh()
    signal wellComeToggle(bool checked)
    signal wellComeReplayToggle(bool checked)
    signal wellComeReplayTimeRefresh()
    signal screenToggle(bool checked)
    signal screenTimeRefresh()
    signal helpToggle(bool checked)
    signal helpTimeRefresh()
    signal refreshHelpContent()
    signal danmuToggle(bool checked)
    signal clickHelpSelectIndex(int index)
    signal clickScreenSelectIndex(int index)
    signal helpContentChange(int selectIndex , string content)
    signal helpTitleChange(int selectIndex , string content)
    signal screenContentChange(int selectIndex, string content)
    signal screenTitleChange(int selectIndex, string content)
    signal selectFile(string type , string filePath)

    //    function clickdOpenWeChat()
    //    {
    //        // 测试
    //         refreshLogin([{nickname: "你好", avatar: "images/L1.png"},{nickname: "你好2", avatar: "images/L1.png"}])
    //    }
    Component.onCompleted:
    {
//         setLoginMsgContent(["a","b"])
         //refreshLogin([{nickname: "你好", avatar: "images/图层 2.png"},{nickname: "你好2", avatar: "images/L1.png"}])
        //                refreshHelpContent([{content:"你好"},{content:"我好"}])
        // setWellComeModel(["a","b"])
        // setHelpTitleText(["aa","bb"])
        //refreshLoginMsg(["aa","bb"])
        setExpiredDatetime("")
    }

    function refreshLogin(loginInfos)
    {
        loginListModel.clear()
        for (let i = 0; i < loginInfos.length; i++) {
            let loginInfo = loginInfos[i]
            let childrenModel = Qt.createQmlObject('import QtQuick 2.0; ListModel {}', loginListModel);
            loginListModel.append({
                        parentModel : {index : i, state: 1, nickname: loginInfo.nickname, avatar: loginInfo.avatar},
                        childrenModel : childrenModel
                        });
        }
        let childrenModel = Qt.createQmlObject('import QtQuick 2.0; ListModel {}', loginListModel);
        loginListModel.append({
                    parentModel : {index : loginInfos.length, state: 0, nickname: "", avatar: ""},
                    childrenModel : childrenModel
                    });
    }

    function refreshLoginMsg(msgInfos)
    {
        for (let i = 0; i < loginListModel.count; i++)
        {
            let parentItem = loginListModel.get(i);
            parentItem.childrenModel.clear();
            for (let j = 0; j < msgInfos.length; j++)
            {
               parentItem.childrenModel.append({"content":msgInfos[j]});
            }
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
    function getWellComeTime()
    {
        return wellcometime.text
    }

    function getHelpTime(){
        return helptime.text
    }
    function getScreenTime(){
        return screenTime.text
    }
    function getLikeTime(){
        return likeTime.text
    }
    function getBuyTime(){
        return buyTime.text
    }

    function setWellComeContentIndex(index) {
        wellcome.currentIndex = index
    }

    function setHelpSelectIndex(index)
    {
        helpSelectColumn.helpSelectIndex = index
    }

    function setHelpTitleText(titles){
        helpListModel.clear()
        for (let i = 0; i < titles.length; i++) {
            helpListModel.append({ content: titles[i]});
        }
    }

    function setHelpContentText(content)
    {
        helpContent.text = content
    }

    function getHelpContentText()
    {
        return helpContent.text
    }

    function setScreenSelectIndex(index)
    {
        screenSelectIndex = index
    }

    function setScreenTitleText(titles){
        screenListModel.clear()
        for (let i = 0; i < titles.length; i++) {
            screenListModel.append({ content: titles[i]});
        }
    }

    function setScreenContentText(content)
    {
        screenContent.text = content
    }

    function getScreenContentText()
    {
        return screenContent.text
    }

    function setWellComeModel(contents){
        wellComeModel.clear()
        for (let i = 0; i < contents.length; i++) {
            wellComeModel.append({ "content": contents[i]});
        }
    }

    function setWellComeModelIndex(index){
        wellcome.currentIndex = index
    }

    function setExpiredDatetime(time)
    {
        expiredDatetime.text = time
    }

    visible: true
    color: "#000000"
    width: 1488
    height: 800
    minimumWidth: 1488
    minimumHeight: 800
    title: "直播助手"


    Item {
        id: mainWindow
        //anchors.top: customTitleBar.bottom
        anchors.fill: parent

        FileDialog {
            property string fileDialogtype: ""

            id: fileDialog
            title: "请选择一个txt文件"
            nameFilters: ["Text files (*.txt)"]
            onAccepted: {
                selectFile(fileDialogtype,fileDialog.file);
            }
            onRejected: {
                console.log("未选择文件")
            }
        }

        Image {
            id: image4
            x: 0
            y: 0
            width: 1488
            height: 800
            source: "images/未标题-41.png"
            fillMode: Image.PreserveAspectFit
        }

        Rectangle {
            id: customTitleBar
            x: 62
            width: 1418
            height: 64
            opacity: 1
            color: "#fafafa"
            radius: 5
            border.color: "gray"
            border.width: 0
            anchors.top: parent.top
            transformOrigin: Item.Center
            anchors.topMargin: 0

            MouseArea {
                id: titleBarMouseArea
                anchors.fill: parent
                anchors.leftMargin: 22
                onPressed: window.startSystemMove(mouse)
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
                font.pointSize: 14
                font.family: "Arial"
                horizontalAlignment: Text.AlignLeft
                anchors.left: parent.left
                anchors.leftMargin: 22
            }

            Image {
                id: image222
                x: 1315
                y: 17
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
                x: 1375
                y: 17
                width: 30
                height: 30
                source: "images/图层 12.png"
                fillMode: Image.PreserveAspectFit
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        Qt.quit();
                        quitApplication();
                    }
                }
            }

            Text {
                x: 13
                y: 19
                width: 35
                height: 27
                color: "#757575"
                text: "版本: "
                anchors.left: parent.left
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                font.bold: false
                anchors.leftMargin: 1196
                font.family: "Noto Sans S Chinese Light"
                font.pointSize: 8
            }

            Text {
                x: 4
                y: 19
                width: 41
                height: 27
                color: "#9a9a9a"
                text: "1.0.0"
                anchors.left: parent.left
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                font.bold: false
                anchors.leftMargin: 1237
                font.family: "Noto Sans S Chinese Light"
                font.pointSize: 6
            }

            Text {
                x: -4
                y: 19
                width: 59
                height: 27
                color: "#e96a19"
                text: "到期时间: "
                anchors.left: parent.left
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                font.bold: false
                anchors.leftMargin: 972
                font.family: "Noto Sans S Chinese Light"
                font.pointSize: 8
            }

            Text {
                id: expiredDatetime
                x: -12
                y: 19
                width: 112
                height: 27
                color: "#9a9a9a"
                text: "2024年8月25日"
                anchors.left: parent.left
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                font.bold: false
                anchors.leftMargin: 1047
                font.family: "Noto Sans S Chinese Light"
                font.pointSize: 6
            }



        }
        
        Item {
            id: item1
            opacity: 1
            anchors.fill: parent
            scale: 1
            anchors.rightMargin: -1
            anchors.leftMargin: -1
            anchors.bottomMargin: -1
            anchors.topMargin: -1
            
            BorderImage {
                id: borderImage1
                x: 7
                y: 72
                width: 402
                height: 723
                opacity: 1
                source: "images/L1.png"
                border.bottom: 5
                border.top: 5
                border.right: 5
                border.left: 5
                
                Label {
                    x: 19
                    y: 17
                    width: 82
                    height: 20
                    color: "#7a7d94"
                    text: "用户登录"
                    font.pixelSize: 20
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignTop
                    font.bold: true
                    font.family: "Noto Sans S Chinese Medium"
                }

                Rectangle {
                    id: rectangle3
                    x: 316
                    y: 15
                    width: 65
                    height: 25
                    color: "#dbd8ff"
                    radius: 2
                    border.width: 0
                    MouseArea {
                        anchors.fill: parent
                        onPressed: rectangle3.scale = 0.9
                        anchors.bottomMargin: 0
                        onReleased: rectangle3.scale = 1
                        onClicked: {
                            fileDialog.fileDialogtype = "user"
                            fileDialog.open()
                        }
                    }

                    Text {
                        id: text2
                        color: "#8c7fff"
                        text: qsTr("导入方案")
                        anchors.fill: parent
                        font.pixelSize: 14
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        anchors.bottomMargin: 0
                        font.family: "Noto Sans S Chinese Light"
                    }
                }

                Column {
                    id: helpSelectColumn2
                    x: 427
                    y: 339
                    anchors.fill: parent
                    anchors.rightMargin: 8
                    anchors.bottomMargin: 8
                    anchors.leftMargin: 8
                    anchors.topMargin: 65
                    spacing: 1
                    Repeater {
                        FocusScope {
                            width: 386
                            height: 61
                            Rectangle {
                                x: 0
                                y: 0
                                width: 386
                                height: 61
                                color: "#fafafa"
                                //color: "#ffffff"
                                //border.color: "#7c7c7c"
                                radius: 10


                                Item {
                                    id: login_item_login_none
                                    anchors.fill: parent
                                    visible: model.parentModel.state === 0
                                    Rectangle {
                                        id: rectangle17
                                        color: "#fafafa"
                                        radius: 10
                                        border.color: "#dcdcdc"
                                        border.width: 0
                                        anchors.fill: parent

                                        MouseArea {
                                            anchors.fill: parent
                                            onClicked: clickdOpenWeChat()
                                            onPressed: {rectangle17.scale = 0.95}
                                            onReleased: {rectangle17.scale = 1}
                                        }

                                        Text {
                                            id: text7
                                            color: "#585858"
                                            text: qsTr("登录")
                                            anchors.fill: parent
                                            font.pixelSize: 24
                                            horizontalAlignment: Text.AlignHCenter
                                            verticalAlignment: Text.AlignVCenter
                                            font.bold: true
                                            font.family: "Arial"
                                        }
                                    }
                                }

                                Item {
                                    id: login_item_login
                                    x: 6
                                    y: 71
                                    anchors.fill: parent

                                    visible: model.parentModel.state === 1
                                    Text {
                                        id: login_item_login_name
                                        x: 66
                                        width: 67
                                        height: 38
                                        color: "#878787"
                                        text: model.parentModel.nickname
                                        anchors.verticalCenter: parent.verticalCenter
                                        font.pixelSize: 18
                                        anchors.verticalCenterOffset: 3
                                        font.bold: false
                                        font.family: "Noto Sans S Chinese Medium"
                                    }

                                    ComboBox {
                                        id: login_comboBox
                                        currentIndex: 0
                                        x: 137
                                        width: 196
                                        height: 32
                                        anchors.verticalCenter: parent.verticalCenter
                                        anchors.verticalCenterOffset: 0
                                        editable: true
                                        font.capitalization: Font.MixedCase
                                        font.pointSize: 14
                                        font.family: "Noto Sans S Chinese Light"
                                        font.styleName: "Regular"
                                        model: childrenModel
                                        background: Rectangle {
                                            width: login_comboBox.width
                                            height: login_comboBox.height
                                            color: "#fafafa"
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
                                                    login_comboBox.popup.visible = true
                                                }
                                            }

                                        }

                                        contentItem: TextField {
                                            text: login_comboBox.currentText
                                            font.pixelSize: 13
                                            color: "#646464"
                                            background: Rectangle {
                                                color: "transparent"
                                                border.color: "transparent"
                                                radius: 4
                                            }
                                            padding: 0
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
                                            anchors.fill: parent
                                            source: "images/图层 3.png"
                                            fillMode: Image.Stretch
                                        }

                                        delegate: ItemDelegate {
                                            width: login_comboBox.width
                                            height: 25
                                            background: Rectangle {
                                                id: bg
                                                color: "transparent"
                                                anchors.fill: parent
                                            }

                                            Text {
                                                text: model.content
                                                color: "#646464"  // 设置字体颜色
                                                font.pixelSize: 14
                                                font.family: "Noto Sans S Chinese Light"
                                                anchors.leftMargin: parent
                                            }

                                            onClicked: {
                                                login_comboBox.currentIndex = index
                                                login_comboBox.popup.visible = false
                                            }
                                        }
                                    }


                                    Image {
                                        id: image19
                                        x: 347
                                        y: 15
                                        height: 32
                                        source: "images/图层 2.png"
                                        fillMode: Image.PreserveAspectFit

                                        MouseArea {
                                            anchors.fill: parent
                                            anchors.rightMargin: 0
                                            anchors.bottomMargin: 0
                                            anchors.leftMargin: 0
                                            anchors.topMargin: 0

                                            onClicked: clickSendUserMsg(model.index, login_comboBox.currentText)
                                            onPressed: image19.scale = 0.9
                                            onReleased: image19.scale = 1
                                        }
                                    }

                                    Image {
                                        id: image17
                                        y: 56
                                        height: 2
                                        anchors.left: parent.left
                                        anchors.right: parent.right
                                        source: "images/矩形 7 拷贝 9.png"
                                        anchors.rightMargin: 0
                                        anchors.leftMargin: 0
                                        fillMode: Image.Stretch
                                    }

                                    Item {
                                        id: item2
                                        x: 16
                                        y: 81
                                        anchors.fill: parent
                                        anchors.rightMargin: 337
                                        anchors.leftMargin: 10
                                        anchors.bottomMargin: 10
                                        anchors.topMargin: 10



                                        Image {
                                            id: login_item_login_icon
                                            x: 3
                                            y: 3
                                            width: 37
                                            height: 37
                                            source: model.parentModel.avatar
                                            anchors.bottomMargin: 0
                                            anchors.leftMargin: 0
                                            anchors.topMargin: 0
                                            anchors.rightMargin: 0
                                            visible: true
                                        }

                                        //                                            OpacityMask{
                                        //                                                anchors.fill: rectangle
                                        //                                                source : login_item_login_icon
                                        //                                                maskSource: rectangle
                                        //                                            }
                                        Rectangle {
                                            id: rectangle
                                            x: 0
                                            y: 0
                                            width: 43
                                            height: 43
                                            color: "#002b5362"
                                            radius: 10
                                            border.color: "#f2f3fc"
                                            border.width: 4
                                        }
                                        Image {
                                            id: image2
                                            x: 26
                                            y: -6
                                            width: 20
                                            height: 20
                                            source: "images/图层 4.png"
                                            fillMode: Image.PreserveAspectFit
                                        }
                                    }





                                }

                            }
                        }
                        model: ListModel {
                            id: loginListModel
                        }
                    }
                }
            }
            
            BorderImage {
                id: borderImage2
                x: 410
                y: 72
                width: 808
                height: 99
                visible: true
                source: "images/M0.png"
                border.right: 5
                border.top: 5
                border.left: 5
                border.bottom: 5
                
                Text {
                    id:live_name
                    x: 114
                    y: 25
                    color: "#7a7d94"
                    text: "我的直播间"
                    font.pixelSize: 22
                    font.family: "Noto Sans S Chinese Medium"
                }
                
                Text {
                    x: 114
                    y: 58
                    width: 39
                    height: 18
                    color: "#b1b4d1"
                    text: "在线："
                    font.pixelSize: 16
                    verticalAlignment: Text.AlignVCenter
                    font.bold: false
                    font.family: "Noto Sans S Chinese Medium"
                }
                
                Text {
                    x: 209
                    y: 58
                    width: 39
                    height: 18
                    color: "#b1b4d1"
                    text: "看过："
                    font.pixelSize: 16
                    verticalAlignment: Text.AlignVCenter
                    font.bold: false
                    font.family: "Noto Sans S Chinese Medium"
                }
                
                Text {
                    x: 305
                    y: 58
                    width: 45
                    height: 18
                    color: "#b1b4d1"
                    text: "点赞："
                    font.pixelSize: 16
                    verticalAlignment: Text.AlignVCenter
                    font.bold: false
                    font.family: "Noto Sans S Chinese Medium"
                }
                
                TextField {
                    id: live_search_text
                    x: 471
                    width: 300
                    height: 50
                    color: "#7a7d94"
                    anchors.verticalCenter: parent.verticalCenter
                    horizontalAlignment: Text.AlignHCenter
                    placeholderTextColor: "#d1d1e8"
                    font.family: "Noto Sans S Chinese Medium"
                    selectedTextColor: "#7a7d94"
                    font.pointSize: 10
                    selectionColor: "#7a7d94"
                    placeholderText: "请输入直播间名称"
                    background: Rectangle {
                        color: "#eef2fd" // 更改为你想要的背景颜色
                        radius: 4
                    }
                    
                    Image {
                        id: image5
                        x: 258
                        width: 34
                        height: 37
                        anchors.verticalCenter: parent.verticalCenter
                        source: "images/7780f1ef11d9df701d6c1a5b8033354.png"
                        fillMode: Image.PreserveAspectFit
                        
                        MouseArea {
                            anchors.fill: parent
                            anchors.topMargin: -5
                            anchors.bottomMargin: -6
                            anchors.rightMargin: -6
                            anchors.leftMargin: -8
                            onClicked:
                            {
                                clickSearchLiveByName(live_search_text.text)
                            }
                            onPressed: image5.scale = 0.9
                            onReleased: image5.scale = 1
                        }
                    }
                }
                
                Text {
                    id: live_online_count
                    x: 153
                    y: 58
                    width: 51
                    height: 18
                    color: "#b1b4d1"
                    text: "0"
                    font.pixelSize: 16
                    verticalAlignment: Text.AlignVCenter
                    font.bold: false
                    font.family: "Noto Sans S Chinese Medium"
                }
                
                Text {
                    id: live_look_count
                    x: 247
                    y: 58
                    width: 52
                    height: 18
                    color: "#b1b4d1"
                    text: "0"
                    font.pixelSize: 16
                    verticalAlignment: Text.AlignVCenter
                    font.bold: false
                    font.family: "Noto Sans S Chinese Medium"
                }
                
                Text {
                    id: live_like_count
                    x: 343
                    y: 58
                    width: 56
                    height: 18
                    color: "#b1b4d1"
                    text: "0"
                    font.pixelSize: 16
                    verticalAlignment: Text.AlignVCenter
                    font.bold: false
                    font.family: "Noto Sans S Chinese Medium"
                }

                Item {
                    id: item3
                    x: 306
                    y: 300
                    width: 58
                    height: 58
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.verticalCenterOffset: -1
                    anchors.horizontalCenterOffset: -351
                    anchors.horizontalCenter: parent.horizontalCenter



                    //                                OpacityMask {
                    //                                    anchors.fill: parent
                    //                                    source: login_item_login_icon1
                    //                                    maskSource: rectangle1
                    //                                }
                    Image {
                        id: live_icon
                        x: 1
                        y: 1
                        width: 56
                        height: 56
                        visible: true
                        source: ""
                        anchors.rightMargin: 0
                        anchors.bottomMargin: 0
                        anchors.leftMargin: 0
                        anchors.topMargin: 0
                        anchors.margins: 0
                    }
                    Rectangle {
                        id: rectangle1
                        x: -2
                        y: -2
                        width: 62
                        height: 62
                        color: "#0096e1fd"
                        radius: 10
                        border.color: "#f2f3fc"
                        border.width: 4
                    }
                }
                
                
            }

            BorderImage {
                id: borderImage3
                x: 410
                y: 174
                width: 402
                height: 171
                source: "images/M1.png"
                border.right: 5
                border.top: 5
                border.left: 5
                border.bottom: 5
                
                Text {
                    x: 24
                    y: 18
                    color: "#7a7d94"
                    text: "自动欢迎"
                    font.pixelSize: 20
                    font.styleName: "Regular"
                    font.bold: true
                    font.family: "Noto Sans S Chinese Medium"
                }
                
                Text {
                    x: 25
                    y: 123
                    color: "#7a7d94"
                    text: "秒 / 间隔"
                    font.pixelSize: 14
                    font.family: "Noto Sans S Chinese Medium"
                }
                
                CheckBox {
                    id: checkBox6
                    x: 290
                    y: 70
                    width: 100
                    height: 20
                    text: qsTr("自动切换")
                    scale: 1
                    indicator: Rectangle {
                        width: 20
                        height: 20
                        //color: "#00ffffff"
                        color: checkBox6.checked ? "#65896f" : "transparent"
                        radius: 5
                        border.color: "#b7b7b7"
                        border.width: 1
                        
                        Text {
                            anchors.centerIn: parent
                            text: checkBox6.checked ? "\u2713" : "" // Unicode字符“✔”表示勾勾
                            color: "white"
                            font.pixelSize: 16
                        }
                    }
                    contentItem: Text {
                        width: 70
                        height: 40
                        color: "#7a7d94"
                        text: checkBox6.text
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        font.pixelSize: 16
                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignVCenter
                        anchors.leftMargin: 20
                        font.family: "Noto Sans S Chinese Medium"
                        font.bold: false
                    }
                    onCheckedChanged: {
                        wellComeToggle(checked)
                    }
                }
                
                ComboBox {
                    id: wellcome
                    x: 25
                    y: 64
                    width: 245
                    height: 31
                    textRole: ""
                    currentIndex: 0
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
                    model: ListModel
                    {
                        id: wellComeModel
                    }
                    //                    model: ["我又来回购了", "选项2", "选项3"]
                    font.family: "Noto Sans S Chinese Light"
                    font.pointSize: 14
                    contentItem: TextField {
                        color: "#646464"
                        text: wellcome.currentText
                        font.pixelSize: 14
                        padding: 0
                        background: Rectangle {
                            color: "#00000000"
                            radius: 4
                            border.color: "#00000000"
                        }
                    }
                    font.capitalization: Font.MixedCase
                    background: Rectangle {
                        width: wellcome.width
                        height: wellcome.height
                        color: "#fafafa"
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
                                wellcome.popup.visible = true
                            }
                        }
                    }
                    
                    BorderImage {
                        id: borderImage
                        anchors.fill: parent
                        source: "images/图层 3.png"
                        border.bottom: 10
                        border.top: 10
                        border.right: 100
                        border.left: 10
                    }
                    
                    delegate: ItemDelegate {
                        width: wellcome.width
                        height: 25
                        background: Rectangle {
                            id: bg1
                            color: "transparent"
                            anchors.fill: parent
                        }
                        
                        Text {
                            text: modelData
                            color: "#646464"  // 设置字体颜色
                            font.pixelSize: 13
                            font.family: "Noto Sans S Chinese Light"
                            anchors.leftMargin: parent
                        }
                        
                        onClicked: {
                            wellcome.currentIndex = index
                            wellcome.popup.visible = false
                        }
                    }
                }
                
                Rectangle {
                    id: rectangle24
                    x: 127
                    y: 116
                    width: 121
                    height: 28
                    color: "#fafafa"
                    radius: 4
                    border.color: "#ececec"
                    Text {
                        id: likeTime2
                        x: 26
                        width: 69
                        color: "#7f7f7f"
                        text: "3"
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        font.pixelSize: 14
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        anchors.bottomMargin: 2
                        anchors.topMargin: 2
                        font.family: "Noto Sans S Chinese Light"
                    }
                    
                    Image {
                        id: image53
                        x: 1
                        width: 26
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        source: "images/图层 8.png"
                        MouseArea {
                            anchors.fill: parent
                            onPressed: image42.scale = 0.9
                            onReleased: image42.scale = 1
                            onClicked: {
                                likeTime2.text = likeTime2.text - 1
                                likeTimeRefresh()
                            }
                        }
                        fillMode: Image.PreserveAspectFit
                        anchors.bottomMargin: 1
                        anchors.topMargin: 1
                    }
                    
                    Image {
                        id: image54
                        x: 95
                        width: 26
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        source: "images/图层 7.png"
                        MouseArea {
                            anchors.fill: parent
                            onPressed: image42.scale = 0.9
                            onReleased: image42.scale = 1
                            anchors.bottomMargin: 0
                            onClicked: {
                                likeTime2.text = parseFloat(likeTime2.text) + 1
                                likeTimeRefresh()
                            }
                        }
                        fillMode: Image.PreserveAspectFit
                        anchors.bottomMargin: 1
                        anchors.topMargin: 1
                    }
                }
                
                CheckBox {
                    id: checkBox9
                    x: 290
                    y: 120
                    width: 100
                    height: 20
                    text: qsTr("自动切换")
                    indicator: Rectangle {
                        width: 20
                        height: 20
                        color: checkBox9.checked ? "#65896f" : "transparent"
                        radius: 5
                        border.color: "#b7b7b7"
                        Text {
                            color: "#ffffff"
                            text: checkBox9.checked ? "\u2713" : ""
                            font.pixelSize: 16
                            anchors.centerIn: parent
                        }
                    }
                    contentItem: Text {
                        width: 70
                        height: 40
                        color: "#7a7d94"
                        text: "自动回复"
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        font.pixelSize: 16
                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignVCenter
                        font.bold: false
                        anchors.leftMargin: 20
                        font.family: "Noto Sans S Chinese Medium"
                    }
                    scale: 1

                    onCheckedChanged: {
                        wellComeReplayToggle(checked)
                    }
                }

                Rectangle {
                    id: rectangle5
                    x: 316
                    y: 16
                    width: 65
                    height: 25
                    color: "#dbd8ff"
                    radius: 2
                    border.width: 0
                    MouseArea {
                        anchors.fill: parent
                        onPressed: rectangle5.scale = 0.9
                        anchors.bottomMargin: 0
                        onReleased: rectangle5.scale = 1
                        onClicked: {
                            fileDialog.fileDialogtype = "wellcome"
                            fileDialog.open()
                        }
                    }

                    Text {
                        id: text4
                        color: "#8c7fff"
                        text: qsTr("导入方案")
                        anchors.fill: parent
                        font.pixelSize: 14
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        anchors.bottomMargin: 0
                        font.family: "Noto Sans S Chinese Light"
                    }
                }
                
                
            }
            
            BorderImage {
                id: borderImage4
                x: 815
                y: 174
                width: 402
                height: 171
                source: "images/M1.png"
                border.right: 5
                border.top: 5
                border.left: 5
                border.bottom: 5
                
                Text {
                    x: 25
                    y: 18
                    color: "#7a7d94"
                    text: "自动功能"
                    font.pixelSize: 18
                    font.bold: true
                    font.family: "Noto Sans S Chinese Medium"
                }
                
                Rectangle {
                    id: rectangle20
                    x: 129
                    y: 66
                    width: 121
                    height: 28
                    color: "#fafafa"
                    radius: 4
                    border.color: "#ececec"
                    Text {
                        id: likeTime
                        x: 26
                        width: 69
                        color: "#7f7f7f"
                        text: "3"
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        font.pixelSize: 14
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font.family: "Noto Sans S Chinese Light"
                        anchors.bottomMargin: 2
                        anchors.topMargin: 2
                    }
                    
                    Image {
                        id: image47
                        x: 1
                        width: 26
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        source: "images/图层 8.png"
                        anchors.topMargin: 1
                        anchors.bottomMargin: 1
                        fillMode: Image.PreserveAspectFit
                        MouseArea {
                            anchors.fill: parent
                            onClicked:
                            {
                                likeTime.text = likeTime.text - 1
                                likeTimeRefresh()
                            }
                            onPressed: image42.scale = 0.9
                            onReleased: image42.scale = 1
                        }
                    }
                    
                    Image {
                        id: image48
                        x: 95
                        width: 26
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        source: "images/图层 7.png"
                        anchors.topMargin: 1
                        anchors.bottomMargin: 1
                        fillMode: Image.PreserveAspectFit
                        MouseArea {
                            anchors.fill: parent
                            anchors.bottomMargin: 0
                            onClicked:
                            {
                                likeTime.text = parseFloat(likeTime.text) + 1
                                likeTimeRefresh()
                            }
                            onPressed: image42.scale = 0.9
                            onReleased: image42.scale = 1
                        }
                    }
                }
                
                CheckBox {
                    id: checkBox12
                    x: 290
                    y: 70
                    width: 100
                    height: 20
                    text: qsTr("自动切换")
                    indicator: Rectangle {
                        width: 20
                        height: 20
                        color: checkBox12.checked ? "#65896f" : "transparent"
                        radius: 5
                        border.color: "#b7b7b7"
                        Text {
                            color: "#ffffff"
                            text: checkBox12.checked ? "\u2713" : ""
                            font.pixelSize: 16
                            anchors.centerIn: parent
                        }
                    }
                    onCheckedChanged: {
                        likeToggle(checked)
                    }
                    contentItem: Text {
                        width: 70
                        height: 40
                        color: "#7a7d94"
                        text: "自动点赞"
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        font.pixelSize: 16
                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignVCenter
                        font.bold: false
                        anchors.leftMargin: 20
                        font.family: "Noto Sans S Chinese Medium"
                    }
                    scale: 1
                }
                
                CheckBox {
                    id: checkBox13
                    x: 290
                    y: 122
                    width: 100
                    height: 20
                    text: qsTr("自动切换")
                    indicator: Rectangle {
                        width: 20
                        height: 20
                        color: checkBox13.checked ? "#65896f" : "transparent"
                        radius: 5
                        border.color: "#b7b7b7"
                        Text {
                            color: "#ffffff"
                            text: checkBox13.checked ? "\u2713" : ""
                            font.pixelSize: 16
                            anchors.centerIn: parent
                        }
                    }
                    contentItem: Text {
                        width: 70
                        height: 40
                        color: "#7a7d94"
                        text: "自动购买"
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        font.pixelSize: 16
                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignVCenter
                        font.bold: false
                        anchors.leftMargin: 20
                        font.family: "Noto Sans S Chinese Medium"
                    }
                    scale: 1

                    onCheckedChanged: {
                        buyToggle(checked)
                    }
                }
                
                Text {
                    x: 38
                    y: 74
                    width: 56
                    height: 14
                    color: "#7a7d94"
                    text: "秒 / 间隔"
                    font.pixelSize: 14
                    font.family: "Noto Sans S Chinese Medium"
                }
                
                Rectangle {
                    id: rectangle22
                    x: 129
                    y: 118
                    width: 121
                    height: 28
                    color: "#fafafa"
                    radius: 4
                    border.color: "#ececec"
                    Text {
                        id: likeTime1
                        x: 26
                        width: 69
                        color: "#7f7f7f"
                        text: "3"
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        font.pixelSize: 14
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        anchors.bottomMargin: 2
                        anchors.topMargin: 2
                        font.family: "Noto Sans S Chinese Light"
                    }
                    
                    Image {
                        id: image49
                        x: 1
                        width: 26
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        source: "images/图层 8.png"
                        MouseArea {
                            anchors.fill: parent
                            onPressed: image42.scale = 0.9
                            onReleased: image42.scale = 1
                            onClicked: {
                                likeTime1.text = likeTime1.text - 1
                                likeTimeRefresh()
                            }
                        }
                        fillMode: Image.PreserveAspectFit
                        anchors.bottomMargin: 1
                        anchors.topMargin: 1
                    }
                    
                    Image {
                        id: image50
                        x: 95
                        width: 26
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        source: "images/图层 7.png"
                        MouseArea {
                            anchors.fill: parent
                            onPressed: image42.scale = 0.9
                            onReleased: image42.scale = 1
                            anchors.bottomMargin: 0
                            onClicked: {
                                likeTime1.text = parseFloat(likeTime1.text) + 1
                                likeTimeRefresh()
                            }
                        }
                        fillMode: Image.PreserveAspectFit
                        anchors.bottomMargin: 1
                        anchors.topMargin: 1
                    }
                }
                
                Text {
                    x: 38
                    y: 126
                    width: 56
                    height: 14
                    color: "#7a7d94"
                    text: "秒 / 间隔"
                    font.pixelSize: 14
                    font.family: "Noto Sans S Chinese Medium"
                }
                
                
                
            }
            
            BorderImage {
                id: borderImage5
                x: 410
                y: 352
                width: 403
                height: 443
                source: "images/M2.png"
                border.right: 5
                border.top: 5
                border.left: 5
                border.bottom: 5
                
                Rectangle {
                    id: rectangle8
                    x: 24
                    y: 76
                    width: 116
                    height: 348
                    color: "#fafafa"
                    radius: 4
                    border.color: "lightgray"
                    border.width: 0
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    anchors.rightMargin: 263
                    anchors.bottomMargin: 19
                    
                    
                    Column {
                        property int helpSelectIndex: 0
                        anchors.fill: parent
                        anchors.topMargin: 8
                        
                        id: helpSelectColumn
                        
                        spacing: 1
                        
                        Repeater {
                            model: ListModel
                            {
                                id: helpListModel
                            }
                            delegate: FocusScope {
                                width: 116
                                height: 30
                                
                                Rectangle {
                                    id: container
                                    width: 116
                                    height: 30
                                    color: helpSelectColumn.helpSelectIndex == index ? "#deebf9" : "#fafafa"
                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked:
                                        {
                                            helpSelectColumn.helpSelectIndex = index
                                            clickHelpSelectIndex(helpSelectColumn.helpSelectIndex)
                                            
                                            if (textInput.visible) {
                                                textInput.visible = false
                                                buttonText.visible = true
                                            } else {
                                                console.log("Button clicked: " + buttonText.text)
                                            }
                                        }
                                        onDoubleClicked: {
                                            helpSelectColumn.helpSelectIndex = index
                                            textInput.visible = true
                                            buttonText.visible = false
                                            textInput.forceActiveFocus()
                                        }
                                        onPressed: image42.scale = 0.9
                                        onReleased: image42.scale = 1
                                    }
                                    
                                    Text {
                                        id: buttonText
                                        color: "#8592aa"
                                        text: model.content
                                        anchors.verticalCenter: parent.verticalCenter
                                        font.pixelSize: 14
                                        font.bold: false
                                        anchors.horizontalCenter: parent.horizontalCenter
                                    }
                                    
                                    Image {
                                        id: containerimage8
                                        x: 0
                                        y: 29
                                        width: 116
                                        height: 1
                                        source: "images/图层 11.png"
                                        fillMode: Image.PreserveAspectFit
                                    }
                                    
                                    TextInput {
                                        id: textInput
                                        anchors.fill: parent
                                        anchors.verticalCenter: parent.verticalCenter
                                        visible: false
                                        text: modelData
                                        onAccepted: {
                                            buttonText.text = text
                                            visible = false
                                            buttonText.visible = true
                                        }
                                        Keys.onReturnPressed: {
                                            buttonText.text = text
                                            visible = false
                                            buttonText.visible = true
                                        }
                                        onEditingFinished: {
                                            buttonText.text = text
                                            visible = false
                                            buttonText.visible = true
                                            helpTitleChange(helpSelectColumn.helpSelectIndex,text)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                
                CheckBox {
                    id: checkBox11
                    x: 295
                    y: 50
                    width: 100
                    height: 20
                    text: qsTr("自动切换")
                    indicator: Rectangle {
                        width: 20
                        height: 20
                        color: checkBox11.checked ? "#65896f" : "transparent"
                        radius: 5
                        border.color: "#b7b7b7"
                        Text {
                            color: "#ffffff"
                            text: checkBox11.checked ? "\u2713" : ""
                            font.pixelSize: 16
                            anchors.centerIn: parent
                        }
                    }
                    contentItem: Text {
                        width: 70
                        height: 40
                        color: "#7a7d94"
                        text: "自动发言"
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        font.pixelSize: 16
                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignVCenter
                        font.bold: false
                        anchors.leftMargin: 20
                        font.family: "Noto Sans S Chinese Medium"
                    }
                    scale: 1
                    onCheckedChanged: {
                        helpToggle(checked)
                    }
                }
                
                Rectangle {
                    id: rectangle23
                    x: 162
                    y: 93
                    width: 219
                    height: 331
                    color: "#fafafa"
                    radius: 5
                    border.color: "#eef2fd"
                    border.width: 2

                    ScrollView {
                        id: scrollView1
                        x: 5
                        y: 5
                        width: 209
                        height: 321
                        clip: true

                        TextEdit {
                            id: helpContent
                            x: 0
                            y: 0
                            width: 209
                            height: 321
                            color: "#7a7d94"
                            text: qsTr("")
                            font.pixelSize: 14
                            font.family: "Noto Sans S Chinese Medium"
                            onTextChanged: {
                                helpContentChange(helpSelectColumn.helpSelectIndex,text)
                            }
                        }
                        contentWidth: 0
                    }
                }
                
                Text {
                    x: 24
                    y: 23
                    color: "#7a7d94"
                    text: "互助发言"
                    font.pixelSize: 20
                    font.bold: true
                    font.family: "Noto Sans S Chinese Medium"
                }
                
                Text {
                    x: 113
                    y: 51
                    color: "#7a7d94"
                    text: "秒 / 间隔"
                    font.pixelSize: 16
                    font.family: "Noto Sans S Chinese Medium"
                }
                
                Rectangle {
                    id: rectangle27
                    x: 194
                    y: 45
                    width: 94
                    height: 28
                    color: "#fafafa"
                    radius: 4
                    border.color: "#ececec"
                    Text {
                        id: likeTime3
                        x: 26
                        width: 42
                        color: "#7a7d94"
                        text: "3"
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        font.pixelSize: 14
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        anchors.bottomMargin: 2
                        anchors.topMargin: 2
                        font.family: "Noto Sans S Chinese Medium"
                    }
                    
                    Image {
                        id: image55
                        x: 1
                        width: 26
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        source: "images/图层 8.png"
                        MouseArea {
                            anchors.fill: parent
                            onPressed: image42.scale = 0.9
                            onReleased: image42.scale = 1
                            onClicked: {
                                likeTime3.text = likeTime3.text - 1
                                likeTimeRefresh()
                            }
                        }
                        fillMode: Image.PreserveAspectFit
                        anchors.bottomMargin: 1
                        anchors.topMargin: 1
                    }
                    
                    Image {
                        id: image56
                        x: 68
                        width: 26
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        source: "images/图层 7.png"
                        MouseArea {
                            anchors.fill: parent
                            onPressed: image42.scale = 0.9
                            onReleased: image42.scale = 1
                            anchors.bottomMargin: 0
                            onClicked: {
                                likeTime3.text = parseFloat(likeTime3.text) + 1
                                likeTimeRefresh()
                            }
                        }
                        fillMode: Image.PreserveAspectFit
                        anchors.bottomMargin: 1
                        anchors.topMargin: 1
                    }
                }

                Rectangle {
                    id: rectangle2
                    x: 315
                    y: 18
                    width: 65
                    height: 25
                    color: "#dbd8ff"
                    radius: 2
                    border.width: 0
                    
                    MouseArea {
                        anchors.fill: parent
                        onPressed: rectangle2.scale = 0.9
                        onReleased: rectangle2.scale = 1
                        anchors.bottomMargin: 0
                        onClicked: {
                            fileDialog.fileDialogtype = "help"
                            fileDialog.open()
                        }
                    }

                    Text {
                        id: text1
                        color: "#8c7fff"
                        text: qsTr("导入方案")
                        anchors.fill: parent
                        font.pixelSize: 14
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        anchors.bottomMargin: 0
                        font.family: "Noto Sans S Chinese Light"
                    }
                }

                Rectangle {
                    id: rectangle4
                    x: 315
                    y: 18
                    width: 65
                    height: 25
                    color: "#dbd8ff"
                    radius: 2
                    border.width: 0
                    MouseArea {
                        anchors.fill: parent
                        onPressed: rectangle4.scale = 0.9
                        anchors.bottomMargin: 0
                        onReleased: rectangle4.scale = 1
                        onClicked: {
                            fileDialog.fileDialogtype = "help"
                            fileDialog.open()
                        }
                    }

                    Text {
                        id: text3
                        color: "#8c7fff"
                        text: qsTr("导入方案")
                        anchors.fill: parent
                        font.pixelSize: 14
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        anchors.bottomMargin: 0
                        font.family: "Noto Sans S Chinese Light"
                    }
                }
                
                
            }
            
            BorderImage {
                id: borderImage7
                x: 1219
                y: 72
                width: 264
                height: 723
                source: "images/R1.png"
                border.right: 5
                border.top: 5
                border.left: 5
                border.bottom: 5
                
                Text {
                    x: 23
                    y: 15
                    color: "#7a7d94"
                    text: "实时弹幕"
                    font.pixelSize: 20
                    font.family: "Noto Sans S Chinese Medium"
                    font.bold: true
                }
                
                ScrollView {
                    id: scrollView
                    x: 14
                    y: 53
                    width: 236
                    height: 657
                    contentWidth: 0
                    //width: parent.width.
                    //height: parent.height
                    clip: true
                    
                    Text {
                        id: danmu_content
                        x: 0
                        y: 0
                        width: 222
                        height: 666
                        color: "#9d9d9d"
                        text: "张师傅"
                        wrapMode: Text.WordWrap
                        font.bold: false
                        font.family: "Noto Sans S Chinese Medium"
                        textFormat: Text.RichText
                        font.pixelSize: 14
                        
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
                    x: 198
                    y: 12
                    width: 47
                    height: 26
                    text: "\u5f00"
                    onCheckedChanged: {
                        danmuToggle(checked)
                    }
                    background: Rectangle {
                        color: customSwitch1.checked ? "#e3f1ff" : "#E0E0E0"
                        radius: 14
                        border.color: "#bebebe"
                        border.width: 0
                        implicitWidth: 60
                        implicitHeight: 30
                    }
                    indicator: Rectangle {
                        x: customSwitch1.checked ? parent.width - width - 2 : 2
                        y: 2
                        width: 22
                        height: 22
                        color: customSwitch1.checked ? "#96bbff" : "white"
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

            BorderImage {
                id: borderImage6
                x: 815
                y: 352
                width: 403
                height: 443
                source: "images/M2.png"
                border.top: 5
                border.right: 5
                border.left: 5
                border.bottom: 5
                Rectangle {
                    id: rectangle9
                    x: 24
                    y: 76
                    width: 116
                    height: 348
                    color: "#fafafa"
                    radius: 4
                    border.color: "#d3d3d3"
                    border.width: 0
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 19
                    Column {
                        property int screenSelectIndex: 0
                        id: screenSelectColumn
                        anchors.fill: parent
                        spacing: 1
                        anchors.topMargin: 8
                        Repeater {
                            FocusScope {
                                width: 116
                                height: 30
                                Rectangle {
                                    id: container1
                                    width: 116
                                    height: 30
                                    color: screenSelectColumn.screenSelectIndex == index ? "#deebf9" : "#fafafa"
                                    MouseArea {
                                        anchors.fill: parent
                                        onPressed: image42.scale = 0.9
                                        onReleased: image42.scale = 1
                                        onClicked: {
                                            screenSelectColumn.screenSelectIndex = index
                                            clickScreenSelectIndex(screenSelectColumn.screenSelectIndex)

                                            if (textInput1.visible) {
                                                textInput1.visible = false
                                                buttonText1.visible = true
                                            } else {
                                                console.log("Button clicked: " + buttonText1.text)
                                            }
                                        }
                                        onDoubleClicked: {
                                            screenSelectColumn.screenSelectIndex = index
                                            textInput1.visible = true
                                            buttonText1.visible = false
                                            textInput1.forceActiveFocus()
                                        }
                                    }

                                    Text {
                                        id: buttonText1
                                        color: "#8592aa"
                                        text: model.content
                                        anchors.verticalCenter: parent.verticalCenter
                                        font.pixelSize: 14
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        font.bold: false
                                    }

                                    Image {
                                        id: containerimage9
                                        x: 0
                                        y: 29
                                        width: 116
                                        height: 1
                                        source: "images/图层 11.png"
                                        fillMode: Image.PreserveAspectFit
                                    }

                                    TextInput {
                                        id: textInput1
                                        visible: false
                                        text: modelData
                                        anchors.fill: parent
                                        Keys.onReturnPressed: {
                                            buttonText1.text = text
                                            visible = false
                                            buttonText1.visible = true
                                        }
                                        onAccepted: {
                                            buttonText1.text = text
                                            visible = false
                                            buttonText1.visible = true
                                        }
                                        onEditingFinished: {
                                            buttonText1.text = text
                                            visible = false
                                            buttonText1.visible = true
                                            screenTitleChange(screenSelectColumn.screenSelectIndex,text)
                                        }
                                    }
                                }
                            }
                            model: ListModel {
                                id: screenListModel
                            }
                        }
                    }
                    anchors.rightMargin: 263
                }

                CheckBox {
                    id: checkBox14
                    x: 295
                    y: 50
                    width: 100
                    height: 20
                    text: qsTr("自动切换")
                    indicator: Rectangle {
                        width: 20
                        height: 20
                        color: checkBox14.checked ? "#65896f" : "transparent"
                        radius: 5
                        border.color: "#b7b7b7"
                        Text {
                            color: "#ffffff"
                            text: checkBox14.checked ? "\u2713" : ""
                            font.pixelSize: 16
                            anchors.centerIn: parent
                        }
                    }
                    contentItem: Text {
                        width: 70
                        height: 40
                        color: "#7a7d94"
                        text: "自动飘屏"
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        font.pixelSize: 16
                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignVCenter
                        styleColor: "#7a7d94"
                        font.bold: false
                        anchors.leftMargin: 20
                        font.family: "Noto Sans S Chinese Medium"
                    }
                    scale: 1

                    onCheckedChanged: {
                        screenToggle(checked)
                    }
                }

                Rectangle {
                    id: rectangle25
                    x: 162
                    y: 93
                    width: 219
                    height: 331
                    color: "#fafafa"
                    radius: 5
                    border.color: "#eef2fd"
                    border.width: 2
                    TextEdit {
                        id: screenContent
                        color: "#7a7d94"
                        text: ""
                        anchors.fill: parent
                        font.pixelSize: 14
                        font.styleName: "Medium"
                        anchors.bottomMargin: 5
                        font.bold: true
                        anchors.leftMargin: 5
                        anchors.topMargin: 5
                        font.family: "Noto Sans S Chinese Medium"
                        onTextChanged: {
                            screenContentChange(screenSelectColumn.screenSelectIndex,text)
                        }
                        anchors.rightMargin: 5
                    }
                }

                Text {
                    x: 24
                    y: 23
                    color: "#7a7d94"
                    text: "飘屏发言"
                    font.pixelSize: 20
                    font.bold: true
                    font.family: "Noto Sans S Chinese Medium"
                }

                Text {
                    x: 127
                    y: 51
                    color: "#7a7d94"
                    text: "秒 / 间隔"
                    font.pixelSize: 16
                    font.family: "Noto Sans S Chinese Medium"
                }

                Rectangle {
                    id: rectangle28
                    x: 194
                    y: 45
                    width: 94
                    height: 28
                    color: "#fafafa"
                    radius: 4
                    border.color: "#ececec"
                    Text {
                        id: likeTime4
                        x: 26
                        width: 42
                        color: "#7a7d94"
                        text: "3"
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        font.pixelSize: 14
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        anchors.bottomMargin: 2
                        anchors.topMargin: 2
                        font.family: "Noto Sans S Chinese Medium"
                    }

                    Image {
                        id: image57
                        x: 1
                        width: 26
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        source: "images/图层 8.png"
                        fillMode: Image.PreserveAspectFit
                        anchors.bottomMargin: 1
                        anchors.topMargin: 1
                        MouseArea {
                            anchors.fill: parent
                            onPressed: image42.scale = 0.9
                            onReleased: image42.scale = 1
                            onClicked: {
                                likeTime4.text = likeTime4.text - 1
                                likeTimeRefresh()
                            }
                        }
                    }

                    Image {
                        id: image58
                        x: 68
                        width: 26
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        source: "images/图层 7.png"
                        fillMode: Image.PreserveAspectFit
                        anchors.bottomMargin: 1
                        anchors.topMargin: 1
                        MouseArea {
                            anchors.fill: parent
                            onPressed: image42.scale = 0.9
                            anchors.bottomMargin: 0
                            onReleased: image42.scale = 1
                            onClicked: {
                                likeTime4.text = parseFloat(likeTime4.text) + 1
                                likeTimeRefresh()
                            }
                        }
                    }
                }

                Rectangle {
                    id: rectangle6
                    x: 315
                    y: 18
                    width: 65
                    height: 25
                    color: "#dbd8ff"
                    radius: 2
                    border.width: 0
                    MouseArea {
                        anchors.fill: parent
                        onPressed: rectangle6.scale = 0.9
                        anchors.bottomMargin: 0
                        onReleased: rectangle6.scale = 1
                        onClicked: {
                            fileDialog.fileDialogtype = "screen"
                            fileDialog.open()
                        }
                    }

                    Text {
                        id: text5
                        color: "#8c7fff"
                        text: qsTr("导入方案")
                        anchors.fill: parent
                        font.pixelSize: 14
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        anchors.bottomMargin: 0
                        font.family: "Noto Sans S Chinese Light"
                    }
                }
            }

            
            
            
            
            
            
            
            
            
            
            
            
            
        }
        
    }
    
    
    
}












