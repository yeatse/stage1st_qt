import QtQuick 1.1
import com.nokia.symbian 1.1

Item {
    id: root

    property alias paddingItem: paddingItem

    signal clicked

    implicitWidth: ListView.view.width
    implicitHeight: platformStyle.graphicSizeLarge

    Loader {
        id: faderLoader
        anchors.fill: parent
        sourceComponent: mouseArea.pressed ? faderComponent : undefined
        Component {
            id: faderComponent
            Rectangle {
                anchors.fill: parent
                color: "black"
                opacity: 0.1
            }
        }
    }

    Item {
        id: paddingItem
        anchors {
            fill: parent
            leftMargin: platformStyle.paddingLarge
            rightMargin: privateStyle.scrollBarThickness
            topMargin: platformStyle.paddingLarge
            bottomMargin: platformStyle.paddingLarge
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: root.clicked()
    }
}
