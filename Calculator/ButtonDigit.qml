import QtQuick 2.15
import "."

Item {
    id: buttonDigit
    width: 60
    height: 60
    property alias text: template.text
    ButtonTemplate{
        id: template
        backgroundNormalColor: "#B0D1D8"
        backgroundHoverColor: "#04BFAD"
        textNormalColor: "#024873"
        textHoverColor: "#FFFFFF"
        text: text
    }
}
