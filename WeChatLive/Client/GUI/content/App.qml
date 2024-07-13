import QtQuick 2.15
import QtQuick.Controls 2.15

Window {
    visible: true
        width: 640
        height: 480

        ListView {
            width: parent.width
            height: parent.height

            model: ListModel {
                ListElement { name: "Item 1" }
                ListElement { name: "Item 2" }
                ListElement { name: "Item 3" }
            }

            delegate: ItemDelegate {
                width: parent.width
                height: 50

                property bool hovered: false
                property bool pressed: false

                background: Rectangle {
                    id: bg1
                    color: control.pressed ? "#d3d3d3" : control.hovered ? "#e5e5e5" : "transparent"
                    anchors.fill: parent

                    MouseArea {
                        id: mouseArea
                        anchors.fill: parent
                        onEntered: control.hovered = true
                        onExited: control.hovered = false
                        onPressed: control.pressed = true
                        onReleased: control.pressed = false
                    }
                }

                Text {
                    text: model.name
                    anchors.centerIn: parent
                }
            }
        }
}
