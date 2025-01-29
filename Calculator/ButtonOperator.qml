import QtQuick 2.15
import "."

Item {
    id: buttonOperator
    width: 60
    height: 60
    property alias text: template.text
    property alias onPermHoverColor: template.onPermHoverColor
    property color backgroundNormalColor: "#0889A6"
    property color backgroundHoverColor: "#F7E425"
    property color textNormalColor: "#FFFFFF"
    property color textHoverColor: "#FFFFFF"
    ButtonTemplate{
        id: template
        backgroundNormalColor: buttonOperator.backgroundNormalColor
        backgroundHoverColor: buttonOperator.backgroundHoverColor
        textNormalColor: buttonOperator.textNormalColor
        textHoverColor: buttonOperator.textHoverColor
        onPermHoverColor: buttonOperator.onPermHoverColor
        text: text
    }
}
