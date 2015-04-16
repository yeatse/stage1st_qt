import QtQuick 1.1
import com.nokia.symbian 1.1

Item {
    id: root

    property alias text: button.text
    signal clicked

    width: screen.width
    height: visible ? platformStyle.graphicSizeLarge : 0

    Button {
        id: button
        anchors.centerIn: parent
        width: parent.width - platformStyle.paddingLarge * 2
        platformInverted: true
        onClicked: root.clicked()
    }
}
