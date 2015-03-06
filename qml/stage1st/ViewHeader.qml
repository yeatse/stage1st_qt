import QtQuick 1.1
import "style.js" as Style

Rectangle {
    id: root

    property alias title: text.text

    signal clicked

    implicitWidth: screen.width
    implicitHeight: visible ? privateStyle.tabBarHeightPortrait : 0
    color: Style.S1_DEEP
    z: 10

    Rectangle {
        id: mask
        anchors.fill: parent
        color: "black"
        opacity: mouseArea.pressed ? 0.3 : 0
    }

    Image {
        anchors { left: parent.left; top: parent.top }
        source: "meegoTLCorner.png"
    }
    Image {
        anchors { right: parent.right; top: parent.top }
        source: "meegoTRCorner.png"
    }

    Text {
        id: text
        anchors {
            left: parent.left; right: parent.right
            margins: platformStyle.paddingLarge + platformStyle.paddingSmall
            verticalCenter: parent.verticalCenter
        }
        font.pixelSize: platformStyle.fontSizeLarge+2
        color: platformStyle.colorNormalLightInverted
        style: Text.Raised
        styleColor: platformStyle.colorNormalMidInverted
        maximumLineCount: 2
        elide: Text.ElideRight
        wrapMode: Text.WrapAnywhere
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: root.clicked()
    }
}
