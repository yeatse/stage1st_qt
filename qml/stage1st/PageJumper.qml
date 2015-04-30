import QtQuick 1.1
import com.nokia.symbian 1.1

CommonDialog {
    id: root

    property int currentPage: 1
    property int totalPage: 1

    titleText: "跳转到页码：[1-%1]".arg(totalPage)
    buttonTexts: ["确认", "取消"]
    privateCloseIcon: true

    content: Item {
        id: contentItem
        width: parent.width
        height: row.height + platformStyle.paddingLarge*2

        Row {
            id: row
            anchors {
                left: parent.left; right: parent.right
                margins: platformStyle.paddingLarge
                verticalCenter: parent.verticalCenter
            }
            Slider {
                id: slider
                width: parent.width - textField.width
                value: root.currentPage
                minimumValue: 1
                maximumValue: root.totalPage
                stepSize: 1
                onValueChanged: root.currentPage = value
            }
            TextField {
                id: textField
                focus: true
                anchors.verticalCenter: parent.verticalCenter
                text: root.currentPage
                validator: IntValidator {
                    bottom: 1; top: root.totalPage
                }
                onTextChanged: root.currentPage = text || 1
                inputMethodHints: Qt.ImhDigitsOnly
            }
        }
    }

    onButtonClicked: index === 0 ? accept() : reject()
}
