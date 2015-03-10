import QtQuick 1.1
import com.nokia.symbian 1.1
import "api.js" as Api
import "style.js" as Style

Page {
    id: mainPage

    function refresh() {
        busyInd.visible = true
        var s = function() {
            busyInd.visible = false
            buildCategory()
            buildList()
        }
        var f = function(err) {
            busyInd.visible = false
            console.debug(err)
        }
        Api.getForumIndex(s, f)
    }

    function buildList() {
        listModel.clear()
        for (var i in Api.ForumList) {
            listModel.append(Api.ForumList[i])
        }
    }

    function buildCategory() {

    }

    tools: ToolBarLayout {
        ToolButton {
            iconSource: "toolbar-back"
            platformInverted: true
            onClicked: Qt.quit()
        }

        ToolButton {
            iconSource: "toolbar-refresh"
            platformInverted: true
            enabled: !busyInd.visible
            onClicked: refresh()
        }

        ToolButton {
            iconSource: "internet_inverted.svg"
            platformInverted: true
        }

        ToolButton {
            iconSource: "toolbar-settings"
            platformInverted: true
            onClicked: pageStack.push(Qt.resolvedUrl("LoginPage.qml"))
        }
    }

    ViewHeader {
        id: viewHeader
        title: "全部"
        onClicked: forumList.positionViewAtBeginning()

        Image {
            anchors {
                right: parent.right
                rightMargin: platformStyle.paddingLarge
                verticalCenter: parent.verticalCenter
            }
            sourceSize.width: platformStyle.graphicSizeSmall
            sourceSize.height: platformStyle.graphicSizeSmall
            source: privateStyle.imagePath("qtg_graf_choice_list_indicator", true)
        }
    }

    ListView {
        id: forumList
        anchors { fill: parent; topMargin: viewHeader.height }
        pressDelay: 50
        model: ListModel { id: listModel }
        delegate: ListItem {
            platformInverted: true
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
                    color: Style.S1_BLUE
                }
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

    Component.onCompleted: refresh()
}
