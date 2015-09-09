import QtQuick 1.1
import com.nokia.symbian 1.1
import com.nokia.extras 1.1
import "style.js" as Style
import "api.js" as Api

PageStackWindow {
    id: window

    initialPage: MainPage { id: mainPage }

    QtObject {
        id: internal
        function tintBackground() {
            if (window.hasOwnProperty("color")) {
                window.color = Style.S1_BACKGROUND
            }
            else {
                for (var i = window.children.length - 1; i>=0; i--) {
                    if (window.children[i].hasOwnProperty("color")) {
                        window.children[i].color = Style.S1_BACKGROUND
                        break
                    }
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
        internal.tintBackground()
        Api.s1user = user
        mainPage.refresh()
    }
}
