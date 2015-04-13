import QtQuick 1.1
import com.nokia.symbian 1.1
import com.nokia.extras 1.1
import "style.js" as Style
import "api.js" as Api

PageStackWindow {
    id: window

    platformInverted: true

    initialPage: MainPage { id: mainPage }

    QtObject {
        id: internal
        function initializeStyle() {
            if (window.hasOwnProperty("color")) {
                window.color = Style.S1_LIGHT
            }
            else {
                for (var i = window.children.length - 1; i>=0; i--) {
                    if (window.children[i].hasOwnProperty("color")) {
                        window.children[i].color = Style.S1_LIGHT
                        break
                    }
                }
            }

            var tbar = window.pageStack.toolBar
            for (var i = tbar.children.length - 1; i>=0; i--) {
                if (tbar.children[i].hasOwnProperty("source")) {
                    var bg = tbar.children[i]
                    bg.source = ""
                    Qt.createQmlObject("import QtQuick 1.1;Rectangle{anchors.fill:parent;color:\"%1\"}"
                                       .arg(Style.S1_DEEP), bg)
                    Qt.createQmlObject("import QtQuick 1.1;Rectangle{width:parent.width;height:1;color:\"%1\"}"
                                       .arg(Style.S1_NORMAL), bg)
                }
            }
        }
    }

    S1User {
        id: user
    }

    InfoBanner {
        id: infoBanner
        platformInverted: true
        function showMessage(msg) {
            text = msg||""
            open()
        }
    }

    Component.onCompleted: {
        internal.initializeStyle()
        Api.s1user = user
        mainPage.refresh()
    }
}
