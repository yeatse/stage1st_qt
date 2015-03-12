import QtQuick 1.1
import com.nokia.symbian 1.1

Page {
    id: page

    tools: ToolBarLayout {
        ToolButton {
            iconSource: "toolbar-back"
            onClicked: pageStack.pop()
        }

        ToolButton {
            iconSource: "toolbar-refresh"
        }
    }

    ViewHeader {
        id: viewHeader
    }

    ListView {
        id: listView
        anchors {
            fill: parent
            topMargin: viewHeader.height
        }
        model: ListModel { id: listModel }
    }
}
