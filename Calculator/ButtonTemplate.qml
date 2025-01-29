import QtQuick 2.15
import QtQuick.Controls 2.15


Item {
    id: buttonTemplate
    property alias text: label.text
    property color backgroundNormalColor: "gray"
    property color backgroundHoverColor: "lightgray"
    property color textNormalColor: "black"
    property color textHoverColor: "white"
    property bool onPermHoverColor: false
    width: 60
    height: 60

    Rectangle {
        width: parent.width
        height: parent.height
        color: mouseHandler.hovered || buttonTemplate.onPermHoverColor ? buttonTemplate.backgroundHoverColor : buttonTemplate.backgroundNormalColor
        radius: parent.width / 2
        border.width: 0
    }


    Text {
        id: label
        anchors.centerIn: parent
        text: parent.text
        font.pixelSize: 22
        color: mouseHandler.hovered || buttonTemplate.onPermHoverColor ? buttonTemplate.textHoverColor : buttonTemplate.textNormalColor
    }

    HoverHandler{
        id: mouseHandler
        acceptedDevices: PointerDevice.Mouse
        cursorShape: Qt.PointingHandCursor
    }

}
