import QtQuick 1.1
import com.nokia.symbian 1.1

Page {
    id: page

    tools: ToolBarLayout {
        ToolButton {
            iconSource: "toolbar-back"
            platformInverted: true
            onClicked: pageStack.pop()
        }
    }

    Column {
        width: parent.width
        ViewHeader {
            id: viewHeader
            title: "个人中心"
        }
        ListItemFrame {
            implicitWidth: parent.width
            ListItemText {
                anchors.left: parent.paddingItem.left
                anchors.verticalCenter: parent.verticalCenter
                platformInverted: true
                text: "我的收藏"
            }
        }
        ListItemFrame {
            implicitWidth: parent.width
            ListItemText {
                anchors.left: parent.paddingItem.left
                anchors.verticalCenter: parent.verticalCenter
                platformInverted: true
                text: "我的主题"
            }
        }
        ListItemFrame {
            implicitWidth: parent.width
            ListItemText {
                anchors.left: parent.paddingItem.left
                anchors.verticalCenter: parent.verticalCenter
                platformInverted: true
                text: "我回复的主题"
            }
        }
    }

    Button {
        anchors {
            left: parent.left; right: parent.right; bottom: parent.bottom
            margins: platformStyle.paddingLarge
        }
        platformInverted: true
        text: "退出登录"
    }
}
