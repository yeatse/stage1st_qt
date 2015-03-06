import QtQuick 1.1
import com.nokia.symbian 1.1
import "api.js" as Api
import "style.js" as Style

Page {
    id: mainPage

    tools: ToolBarLayout {
        ToolButton {
            iconSource: "toolbar-back"
            platformInverted: true
            onClicked: Qt.quit()
        }

        ToolButton {
            iconSource: "toolbar-refresh"
            platformInverted: true
        }

        ToolButton {
            iconSource: "internet_inverted.svg"
            platformInverted: true
        }

        ToolButton {
            iconSource: "toolbar-settings"
            platformInverted: true
        }
    }

    ViewHeader {
        id: viewHeader
        title: "全部"
    }

    ListView {
        id: forumList
        anchors { fill: parent; topMargin: viewHeader.height }
    }

    ScrollDecorator {
        platformInverted: true
        flickableItem: forumList
    }

    Component.onCompleted: forumList.buildList()
}
