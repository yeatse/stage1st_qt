import QtQuick 1.1
import com.nokia.symbian 1.1
import "api.js" as Api
import "style.js" as Style

Page {
    id: mainPage

    tools: ToolBarLayout {
        ToolButton {
            iconSource: "toolbar-back"
            onClicked: Qt.quit()
        }

        ToolButton {
            iconSource: "toolbar-refresh"
            enabled: !busyInd.visible
            onClicked: refresh()
        }

        ToolButton {
            iconSource: "internet.svg"
            platformInverted: true
        }

        ToolButton {
            iconSource: "toolbar-settings"
        }
    }

    QtObject {
        id: internal

        function loadFromCache() {
            var cache = qmlApi.loadForumList()

        }

        function loadFromNetwork() {
        }
    }

    function refresh() {
        busyInd.visible = true
        var s = function(list) {
            busyInd.visible = false
            listModel.clear()
            for (var i in list)
                listModel.append(list[i])
        }
        var f = function(err) {
            busyInd.visible = false
            console.debug(err)
        }
        Api.getForumIndex(s, f)
    }

    Connections {
        target: user
        onUserChanged: refresh()
    }

    ViewHeader {
        id: viewHeader
        title: "stage1st"
        onClicked: forumList.positionViewAtBeginning()

        ToolButton {
            anchors {
                right: parent.right
                verticalCenter: parent.verticalCenter
            }
            enabled: !busyInd.visible
            platformInverted: true
            iconSource: "contacts_inverted.svg"
            onClicked: {
                if (user.isValid)
                    pageStack.push(Qt.resolvedUrl("UserCenterPage.qml"))
                else
                    pageStack.push(Qt.resolvedUrl("LoginPage.qml"))
            }
        }
    }

    ListView {
        id: forumList
        anchors { fill: parent; topMargin: viewHeader.height }
        model: ListModel { id: listModel }
        delegate: ListItemFrame {
            Row {
                anchors.left: parent.paddingItem.left
                anchors.verticalCenter: parent.verticalCenter
                spacing: platformStyle.paddingLarge

                ListItemText {
                    text: name
                    platformInverted: true
                }

                ListItemText {
                    text: todayposts == 0 ? "" : todayposts
                    color: "steelblue"
                }
            }
            onClicked: {
                var prop = { forumName: name, forumId: fid }
                pageStack.push(Qt.resolvedUrl("ForumPage.qml"), prop)
            }
        }
    }

    ScrollDecorator {
        platformInverted: true
        flickableItem: forumList
    }

    BusyIndicator {
        id: busyInd
        platformInverted: true
        anchors.centerIn: parent
        width: platformStyle.graphicSizeLarge
        height: platformStyle.graphicSizeLarge
        visible: false
        running: visible
    }
}
