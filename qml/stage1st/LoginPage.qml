import QtQuick 1.1
import com.nokia.symbian 1.1
import "api.js" as Api

Page {
    id: loginPage

    function login() {
        busyInd.visible = true
        var s = function(msg, ret) {
            busyInd.visible = false
            infoBanner.showMessage(msg)
            if (ret == "location_login_succeed_mobile") {
                // TODO: 登录成功
                mainPage.refresh()
                pageStack.pop()
            }
        }
        var f = function(err) {
            busyInd.visible = false
            console.debug(err)
        }
        Api.login(unField.text, pwField.text, s, f);
    }

    tools: ToolBarLayout {
        ToolButton {
            iconSource: "toolbar-back"
            platformInverted: true
            onClicked: pageStack.pop()
        }
    }

    ViewHeader {
        id: viewHeader
        title: "登录"
    }

    Column {
        anchors.top: viewHeader.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: platformStyle.paddingLarge
        spacing: platformStyle.paddingLarge

        TextField {
            id: unField
            placeholderText: "用户名"
            platformInverted: true
            width: parent.width
        }

        TextField {
            id: pwField
            placeholderText: "密码"
            echoMode: TextInput.Password
            platformInverted: true
            width: parent.width
        }

        Button {
            id: loginBtn
            text: "登录"
            platformInverted: true
            width: parent.width
            enabled: unField.text != "" && pwField.text != "" && !busyInd.visible
            onClicked: login()
        }
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
