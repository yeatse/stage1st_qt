import QtQuick 1.1
import com.nokia.symbian 1.1
import "style.js" as Style

PageStackWindow {
    id: window

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

    Component.onCompleted: internal.initializeStyle()
}
