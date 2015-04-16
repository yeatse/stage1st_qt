import QtQuick 1.1
import com.nokia.symbian 1.1
import "api.js" as Api
import "style.js" as Style

Page {
    id: page

    property variant threadInfo: null
    property string title
    property string threadId
    property int pageNumber: 1
    property int pageCount: 1
    property bool requestLoad: true

    onStatusChanged: {
        if (status == PageStatus.Active && requestLoad) {
            requestLoad = false
            getlistTimer.restart()
        }
    }

    function getlist(option) {
        busyInd.visible = true

        var opt = { tid: threadId }

        option = option || "refresh"
        if (option == "next")
            opt.page = pageNumber + 1
        else if (option == "prev")
            opt.page = Math.max(1, pageNumber - 1)
        else if (option == "refresh")
            opt.page = 1
        else
            opt.page = pageNumber

        var s = function(info, list, msg) {
            busyInd.visible = false

            threadInfo = info
            title = info.short_subject
            pageNumber = opt.page
            pageCount = Math.ceil(info.replies / 30)

            if (option != "next" && option != "prev")
                listModel.clear()

            for (var i in list) {
                var item = list[i]
                item.contentList = qmlApi.parseHtml(item.message)
                if (option == "prev")
                    listModel.insert(i, item)
                else
                    listModel.append(item)
            }

            if (msg != "")
                infoBanner.showMessage(msg)
        }
        var f = function(err) {
            busyInd.visible = false
            console.debug(err)
        }
        Api.viewThread(opt, s, f)
    }

    tools: ToolBarLayout {
        ToolButton {
            iconSource: "toolbar-back"
            platformInverted: true
            onClicked: pageStack.pop()
        }

        ToolButton {
            iconSource: "toolbar-refresh"
            enabled: !busyInd.visible
            onClicked: getlist()
            platformInverted: true
        }

        ToolButton {
            iconSource: "edit_inverted.svg"
            platformInverted: true
            enabled: user.isValid && threadInfo != null
        }

        ToolButton {
            iconSource: "toolbar-menu"
            onClicked: menu.open()
            platformInverted: true
        }
    }

    ViewHeader {
        id: viewHeader
        title: page.title
        onClicked: listView.positionViewAtBeginning()
    }

    ListView {
        id: listView
        anchors { fill: parent; topMargin: viewHeader.height }
        cacheBuffer: 200
        spacing: 20
        model: ListModel { id: listModel }
        delegate: ListItemFrame {
            implicitHeight: contentCol.height
            Column {
                id: contentCol
                width: parent.width
                Repeater {
                    model: contentList
                    Text {
                        width: parent.width
                        wrapMode: Text.Wrap
                        text: content
                        color: "black"
                    }
                }
            }
        }
    }

    ScrollDecorator {
        platformInverted: true
        flickableItem: listView
    }

    Menu {
        id: menu
        MenuLayout {
            MenuItem {
                text: "用浏览器打开"
            }
            MenuItem {
                text: "跳页"
            }
            MenuItem {
                text: "设置"
            }
        }
    }

    Timer {
        id: getlistTimer
        interval: 100
        repeat: false
        onTriggered: getlist()
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
