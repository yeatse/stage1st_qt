import QtQuick 1.1

QtObject {
    id: user

    property string userName: ""
    property int userId: 0
    property string auth: ""

    property bool isValid: userName != "" && userId != 0 && auth != ""

    signal userChanged

    function logout() {
        qmlApi.clearCookies()
        userName = "";
        userId = 0
        auth = ""
        userChanged()
    }
}
