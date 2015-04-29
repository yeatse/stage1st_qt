import QtQuick 1.1
import com.nokia.symbian 1.1
import "api.js" as Api
import "style.js" as Style

Page {
    id: page

    property variant forumInfo: null
    property string forumName
    property int forumId
    property int pageNumber: 1
    property bool hasNextPage: false
    property bool requestLoad: true

    onStatusChanged: {
        if (status == PageStatus.Active && requestLoad) {
            requestLoad = false
            getlistTimer.restart()
        }
    }

    function getlist(option) {
        busyInd.visible = true

        var opt = { fid: forumId }
        if (option == "next")
            opt.page = pageNumber + 1
        else if (option == "prev")
            opt.page = Math.max(1, pageNumber - 1)
        else
            opt.page = pageNumber

        var s = function(info, list, subforums, msg) {
            busyInd.visible = false

            forumInfo = info
            forumName = info.name
            forumId = info.fid
            pageNumber = info.page
            hasNextPage = info.posts > info.page * 50

            listModel.clear()
            for (var i in list)
                listModel.append(list[i])

            sublistModel.clear()
            for (var i in subforums)
                sublistModel.append(subforums[i])

            if (msg != "")
                infoBanner.showMessage(msg)
        }
        var f = function(err) {
            busyInd.visible = false
            console.debug(err)
        }
        Api.getForumDisplay(opt, s, f)
    }

    tools: ToolBarLayout {
        ToolButton {
            iconSource: "toolbar-back"
            platformInverted: true
            onClicked: pageStack.pop()
        }

        ToolButton {
            iconSource: "toolbar-previous"
            enabled: !busyInd.visible && pageNumber > 1
            onClicked: getlist("prev")
            platformInverted: true
        }

        ToolButton {
            iconSource: "toolbar-refresh"
            enabled: !busyInd.visible
            onClicked: getlist()
            platformInverted: true
        }

        ToolButton {
            iconSource: "toolbar-next"
            enabled: !busyInd.visible && hasNextPage
            onClicked: getlist("next")
            platformInverted: true
        }

        ToolButton {
            iconSource: "toolbar-menu"
            onClicked: menu.open()
            platformInverted: true
        }
    }

    ViewHeader {
        id: viewHeader
        title: forumName
        onClicked: listView.positionViewAtBeginning()
        Text {
            anchors {
                right: parent.right
                rightMargin: platformStyle.paddingLarge
                verticalCenter: parent.verticalCenter
            }
            font.pixelSize: platformStyle.fontSizeLarge + 2
            text: pageNumber
            color: Style.S1_BLUE
        }
    }

    ListView {
        id: listView
        anchors { fill: parent; topMargin: viewHeader.height }
        cacheBuffer: 8000
        focus: true
        model: ListModel { id: listModel }
        delegate: ListItemFrame {
            implicitHeight: contentCol.height + platformStyle.paddingLarge*2
            onClicked: {
                var prop = { title: subject, threadId: tid }
                pageStack.push(Qt.resolvedUrl("ThreadListPage.qml"), prop)
            }

            Column {
                id: contentCol
                anchors.left: parent.paddingItem.left
                anchors.top: parent.paddingItem.top
                anchors.right: parent.paddingItem.right
                spacing: platformStyle.paddingLarge

                Text {
                    width: parent.width
                    wrapMode: Text.Wrap
                    elide: Text.ElideRight
                    maximumLineCount: 2
                    text: subject
                    color: Style.S1_BLUE
                    font.pixelSize: platformStyle.fontSizeLarge
                }

                Item {
                    width: parent.width
                    height: childrenRect.height
                    Rectangle {
                        id: repRect
                        width: rep.width + 10
                        height: rep.height + 2
                        radius: 2
                        y: -1
                        color: "steelblue"
                        Text {
                            id: rep
                            anchors.centerIn: parent
                            color: "white"
                            font.pixelSize: platformStyle.fontSizeSmall
                            font.weight: Font.Light
                            text: replies
                        }
                    }
                    Text {
                        anchors.left: repRect.right
                        anchors.leftMargin: platformStyle.paddingSmall
                        text: author
                        font.weight: Font.Light
                        font.pixelSize: platformStyle.fontSizeSmall
                        color: platformStyle.colorNormalMidInverted
                    }
                    Text {
                        anchors.right: parent.right
                        text: lastposter
                        font.weight: Font.Light
                        font.pixelSize: platformStyle.fontSizeSmall
                        color: platformStyle.colorNormalMidInverted
                    }
                }
            }
        }

        function pageUp() {
            if (!atYBeginning) {
                contentY -= height
                if (atYBeginning) positionViewAtBeginning()
            }
        }

        function pageDown() {
            if (!atYEnd) {
                contentY += height
                if (atYEnd) positionViewAtEnd()
            }
        }

        Keys.onVolumeUpPressed: pageUp()
        Keys.onVolumeDownPressed: pageDown()
    }

    ScrollDecorator {
        platformInverted: true
        flickableItem: listView
    }

    Menu {
        id: menu
        MenuLayout {
            MenuItem {
                text: "子论坛"
                platformSubItemIndicator: true
                visible: sublistModel.count > 0
                onClicked: subForumMenu.open()
            }
            MenuItem {
                text: "用浏览器打开"
            }
            MenuItem {
                text: "设置"
            }
        }
    }

    ContextMenu {
        id: subForumMenu
        MenuLayout {
            id: menuLayout
            Repeater {
                model: ListModel { id: sublistModel }
                MenuItem {
                    width: menuLayout.width
                    text: name
                    onClicked: {
                        subForumMenu.close()
                        switchForumTimer.prop = { forumName: name, forumId: fid }
                        switchForumTimer.restart()
                    }
                }
            }
        }
    }

    Timer {
        id: getlistTimer
        interval: 100
        repeat: false
        onTriggered: getlist()
    }

    Timer {
        id: switchForumTimer
        property variant prop
        interval: 250
        repeat: false
        onTriggered: pageStack.replace(Qt.resolvedUrl("ForumPage.qml"), prop)
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
