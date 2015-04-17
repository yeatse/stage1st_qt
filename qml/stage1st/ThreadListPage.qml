import QtQuick 1.1
import com.nokia.symbian 1.1
import "api.js" as Api
import "style.js" as Style

Page {
    id: page

    property variant threadInfo: null
    property string title
    property string threadId

    property int topPage: 1
    property int bottomPage: 1
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
            opt.page = bottomPage + 1
        else if (option == "prev")
            opt.page = Math.max(1, topPage - 1)
        else if (option == "refresh")
            opt.page = 1
        else
            opt.page = topPage

        var s = function(info, list, msg) {
            busyInd.visible = false

            threadInfo = info
            title = info.short_subject
            pageCount = Math.ceil(info.replies / 30)

            if (option == "prev") {
                topPage = opt.page
            }
            else if (option == "next") {
                bottomPage = opt.page
            }
            else {
                topPage = bottomPage = opt.page
                listModel.clear()
            }

            for (var i in list) {
                var item = list[i]
                item.contentList = qmlApi.parseHtml(item.message)
                item.avatar = Api.getAvatarSource(item.authorid)
                item.dateline = item.dateline.replace("&nbsp;", " ")
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
        cacheBuffer: 1000
        model: ListModel { id: listModel }
        delegate: ListItemFrame {
            effectEnabled: false
            implicitHeight: contentCol.height + platformStyle.paddingLarge * 2

            Rectangle {
                anchors.bottom: parent.bottom
                width: parent.width
                height: 1
                color: platformStyle.colorDisabledLightInverted
            }

            Column {
                id: contentCol
                anchors {
                    left: parent.paddingItem.left
                    top: parent.paddingItem.top
                    right: parent.paddingItem.right
                }
                spacing: platformStyle.paddingLarge

                Item {
                    width: parent.width
                    height: platformStyle.graphicSizeMedium
                    Image {
                        id: avatarImage
                        width: platformStyle.graphicSizeMedium
                        height: platformStyle.graphicSizeMedium
                        sourceSize { width: width; height: height }
                        source: avatar
                    }
                    Image {
                        anchors.fill: avatarImage
                        source: "photo.png"
                        visible: avatarImage.status != Image.Ready
                    }
                    Column {
                        anchors {
                            left: avatarImage.right
                            leftMargin: platformStyle.paddingMedium
                            verticalCenter: parent.verticalCenter
                        }
                        ListItemText {
                            platformInverted: true
                            text: author
                        }
                        ListItemText {
                            platformInverted: true
                            role: "SubTitle"
                            text: dateline
                        }
                    }
                    ListItemText {
                        anchors.right: parent.right
                        platformInverted: true
                        role: "SubTitle"
                        text: "#"+number
                    }
                }

                Repeater {
                    model: contentList
                    Loader {
                        sourceComponent: format == 2 ? imageComponent : textComponent
                        Component {
                            id: textComponent
                            Text {
                                width: contentCol.width
                                wrapMode: Text.Wrap
                                text: content
                                color: Style.S1_BLUE
                                font.pixelSize: platformStyle.fontSizeMedium + 2
                                font.italic: italic
                                textFormat: format == 1 ? Text.RichText : Text.PlainText
                                onLinkActivated: Qt.openUrlExternally(link)
                            }
                        }
                        Component {
                            id: imageComponent
                            Item {
                                width: image.status == Image.Ready ? image.width : thumbnail.width
                                height: image.status == Image.Ready ? image.height : thumbnail.height
                                Image {
                                    id: image
                                    sourceSize.width: contentCol.width
                                    source: content
                                }
                                Image {
                                    id: thumbnail
                                    visible: image.status != Image.Ready
                                    source: "photos_inverted.svg"
                                }
                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: Qt.openUrlExternally(content)
                                }
                            }
                        }
                    }
                }
            }
        }

        header: FooterItem {
            visible: topPage > 1
            text: "上一页"
            enabled: !busyInd.visible
            onClicked: getlist("prev")
        }

        footer: FooterItem {
            visible: bottomPage < pageCount
            text: "下一页"
            enabled: !busyInd.visible
            onClicked: getlist("next")
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