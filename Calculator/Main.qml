import QtQuick 2.6
import QtQuick.Window
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.0
import "."

Window {
    id: window
    visible: true
    width: 360
    height: 640
    minimumWidth: window.width
    maximumWidth: window.width
    minimumHeight: window.height
    maximumHeight: window.height
    title: qsTr("Калькулятор")


    /* ---------- Секретное меню ---------- */

    Window {
        id: secretWindow
        width: 300
        height: 200
        title: "Секретное окно"
        modality: Qt.ApplicationModal
        visible: false

        Column {
            anchors.centerIn: parent
            spacing: 10

            Text {
                text: "Секретное окно"
                font.pixelSize: 20
                horizontalAlignment: Text.AlignHCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Button {
                width: 100;
                text: "Назад"
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: secretWindow.visible = false
            }
        }
    }

    Timer {
        id: pressButtonTimer
        interval: 4000
        repeat: false
        onTriggered: {
            enterTextTimer.start()
        }
    }

    Timer {
        id: enterTextTimer
        interval: 5000
        repeat: false
    }

    /* ---------- Конец секретного меню ---------- */


    Rectangle {
        anchors.fill: parent
        color: "#024873"
    }

    Rectangle {
        id: historyBox
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.bottom: resultBox.top
    }

    Rectangle {
        id: resultBox
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        height: 180
        border.width: 0
        radius: 30
        color: "#04BFAD"

        Rectangle {
            height: parent.height / 2
            width: parent.width
            color: parent.color
            border.width: 0
        }

        Text{
            id: historyText
            anchors.rightMargin: resultText.anchors.rightMargin + 2
            anchors.leftMargin: resultText.anchors.leftMargin
            anchors.bottomMargin: resultText.anchors.topMargin + 83
            horizontalAlignment: resultText.horizontalAlignment
            verticalAlignment: resultText.verticalAlignment
            anchors.fill: parent
            text: qsTr( "" )
            color: resultText.color
            font.pixelSize: 20
            fontSizeMode: Text.Fit
            font.letterSpacing: 1
        }

        Text {
            id: resultText
            anchors.rightMargin: 40
            anchors.leftMargin: 40
            anchors.bottomMargin: 10
            anchors.fill: parent
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignBottom
            text: qsTr( "0" )
            color: "white"
            font.pixelSize: 50
            fontSizeMode: Text.Fit
            font.letterSpacing: 0.5
            font.weight: 600
        }
    }

    property var currentOperator: ""

    function clickDigit(value){
        if (resultText.text.length === 25)
            return

        var flagBranch = false
        if(resultText.text.endsWith(")")){
            resultText.text = resultText.text.slice(0, -1)
            flagBranch = true
        }

        if (value === "."){
            if (resultText.text.indexOf(value) < 0){
                if (!resultText.text)
                    resultText.text += "0"
                resultText.text += value
            }
        }
        else {
            if(resultText.text === "0")
                resultText.text = value
            else
                resultText.text += value
        }

        if (flagBranch)
            resultText.text += ")"

        if (enterTextTimer.running && resultText.text === "123"){
            secretWindow.visible = true
            enterTextTimer.stop()
        }
    }

    function clickOperator(operator){

        function delBranch(exp){
            var number = exp.replace(/\(|\)/g, "");
            if (number.includes("--"))
                    number = number.replace("--", "");
            return number;
        }

        if (currentOperator === operator)
            return

        var result = 0,
        textVar1 = historyText.text,
        textVar2 = resultText.text,
        textCurOperator = "",
        var1 = Number(delBranch(textVar1)),
        var2 = Number(delBranch(textVar2))


        if (textVar2.endsWith(".)"))
            textVar2 = textVar2.replace(".)", ")")

        var operators = [operatorDivision, operatorMulti, operatorMinus, operatorPlus, operatorRemain]
        if (operators.includes(operator)){
            if (currentOperator)
                currentOperator.onPermHoverColor = false
            else{
                if (!textVar2.includes("-(-"))
                    textVar2 = String(var2)
                historyText.text = textVar2
                resultText.text = ""
            }
            currentOperator = operator
            currentOperator.onPermHoverColor = true
        }

        if(operator === operatorResult && currentOperator){
            if (!textVar2)
                return

            if (!textVar2.includes("-(-"))
                textVar2 = String(var2)

            if (currentOperator === operatorDivision){
                result = var2 ? var1 / var2 : NaN
                textCurOperator = "÷"
            }
            if (currentOperator === operatorMulti){
                result = var1 * var2
                textCurOperator = "x"
            }
            if (currentOperator === operatorMinus){
                result = var1 - var2
                textCurOperator = "-"
            }
            if (currentOperator === operatorPlus){
                result = var1 + var2
                textCurOperator = "+"
            }
            if (currentOperator === operatorRemain){
                result = Math.abs(var1 % var2)
                textCurOperator = "%"
            }

            if (textVar2[0] === "-")
                textVar2 = "(" + textVar2 + ")"
            resultText.text = result
            historyText.text += textCurOperator + textVar2

            currentOperator.onPermHoverColor = false
            currentOperator = ""
        }
    }

    GridLayout {
        id: gridButtons
        anchors.top: resultBox.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        columns: 4
        anchors.leftMargin: 24
        anchors.rightMargin: 5
        anchors.bottomMargin: 30
        anchors.topMargin: 14

        /* --------- Первая строка --------- */
        ButtonOperator{
            id: operatorBracket
            Image {
                id: bracketImage
                anchors.centerIn: parent
                source: "/icons/branch.svg"
            }

            MouseArea{
                id: mouseAreaBracket
                anchors.fill: parent

                onClicked: {
                    if (!resultText.text)
                        return
                    var index = resultText.text.indexOf("(")
                    if (index>=0)
                        resultText.text = resultText.text.slice(index+1, -1)
                    else
                        resultText.text = "(" + resultText.text + ")"
                }
            }
        }

        ButtonOperator{
            id: operatorSign
            Image {
                anchors.centerIn: parent
                source: "/icons/plus_minus.svg"
            }

            MouseArea{
                id: mouseAreaSign
                anchors.fill: parent
                onClicked: {
                    if (resultText.text && resultText.text !== "0"){
                        if (resultText.text[0] === "-")
                            resultText.text = resultText.text.slice(1)
                        else
                            resultText.text = "-" + resultText.text
                    }
                }
            }
        }

        ButtonOperator{
            id: operatorRemain
            Image {
                anchors.centerIn: parent
                source: "/icons/percent.svg"
            }

            MouseArea{
                id: mouseAreaRemain
                anchors.fill: parent
                onClicked: {
                    clickOperator(operatorRemain)
                }
            }
        }

        ButtonOperator{
            id: operatorDivision
            Image {
                anchors.centerIn: parent
                source: "/icons/division.svg"
            }

            MouseArea{
                id: mouseAreaDivision
                anchors.fill: parent
                onClicked: {
                    clickOperator(operatorDivision)
                }
            }
        }

        /* --------- Вторая строка --------- */

        ButtonDigit{
            id: digit7
            text: "7"

            MouseArea{
                id: mouseArea7
                anchors.fill: parent
                onClicked: {
                    clickDigit(parent.text);
                }
            }
        }

        ButtonDigit{
            id: digit8
            text: "8"

            MouseArea{
                id: mouseArea8
                anchors.fill: parent
                onClicked: {
                    clickDigit(parent.text);
                }
            }
        }

        ButtonDigit{
            id: digit9
            text: "9"

            MouseArea{
                id: mouseArea9
                anchors.fill: parent
                onClicked: {
                    clickDigit(parent.text);
                }
            }
        }

        ButtonOperator{
            id: operatorMulti
            Image {
                anchors.centerIn: parent
                source: "/icons/multi.svg"
            }

            MouseArea{
                id: mouseAreaMulti
                anchors.fill: parent
                onClicked: {
                    clickOperator(operatorMulti)
                }
            }
        }

        /* --------- Третья строка --------- */

        ButtonDigit{
            id: digit4
            text: "4"

            MouseArea{
                id: mouseArea4
                anchors.fill: parent
                onClicked: {
                    clickDigit(parent.text);
                }
            }
        }

        ButtonDigit{
            id: digit5
            text: "5"

            MouseArea{
                id: mouseArea5
                anchors.fill: parent
                onClicked: {
                    clickDigit(parent.text);
                }
            }
        }

        ButtonDigit{
            id: digit6
            text: "6"

            MouseArea{
                id: mouseArea6
                anchors.fill: parent
                onClicked: {
                    clickDigit(parent.text);
                }
            }
        }

        ButtonOperator{
            id: operatorMinus
            Image {
                anchors.centerIn: parent
                source: "/icons/minus.svg"
            }

            MouseArea{
                id: mouseAreaMinus
                anchors.fill: parent
                onClicked: {
                    clickOperator(operatorMinus)
                }
            }
        }

        /* --------- Четвертая строка --------- */

        ButtonDigit{
            id: digit1
            text: "1"

            MouseArea{
                id: mouseArea1
                anchors.fill: parent
                onClicked: {
                    clickDigit(parent.text);
                }
            }
        }

        ButtonDigit{
            id: digit2
            text: "2"

            MouseArea{
                id: mouseArea2
                anchors.fill: parent
                onClicked: {
                    clickDigit(parent.text);
                }
            }
        }

        ButtonDigit{
            id: digit3
            text: "3"

            MouseArea{
                id: mouseArea3
                anchors.fill: parent
                onClicked: {
                    clickDigit(parent.text);
                }
            }
        }

        ButtonOperator{
            id: operatorPlus
            Image {
                anchors.centerIn: parent
                source: "/icons/plus.svg"
            }

            MouseArea{
                id: mouseAreaPlus
                anchors.fill: parent
                onClicked: {
                    clickOperator(operatorPlus)
                }
            }
        }

        /* --------- Пятая строка --------- */

        ButtonOperator{
            id: operatorClear
            text: "C"
            backgroundNormalColor: "#F9AFB0"
            backgroundHoverColor: "#F25E5E"

            MouseArea{
                id: mouseAreaClear
                anchors.fill: parent
                onClicked: {
                    resultText.text = "0"
                }
            }
        }

        ButtonDigit{
            id: digit0
            text: "0"

            MouseArea{
                id: mouseArea0
                anchors.fill: parent
                onClicked: {
                    clickDigit(parent.text);
                }
            }
        }

        ButtonDigit{
            id: digitPoint
            text: "."

            MouseArea{
                id: mouseAreaPoint
                anchors.fill: parent
                onClicked: {
                    clickDigit(parent.text);
                }
            }
        }

        ButtonOperator{
            id: operatorResult
            Image {
                anchors.centerIn: parent
                source: "/icons/equal.svg"
            }

            MouseArea{
                id: mouseAreaResult
                anchors.fill: parent
                onClicked: {
                    clickOperator(operatorResult)
                }
                onPressed: {
                    pressButtonTimer.start()
                }
                onReleased: {
                    pressButtonTimer.stop()
                }
            }
        }

    }



}
