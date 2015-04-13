TEMPLATE = app
TARGET = stage1st

VERSION = 1.0.0
DEFINES += VER=\\\"$$VERSION\\\"

QT += network

HEADERS += \
    networkaccessmanagerfactory.h \
    singletonbase.h \
    qmlapi.h

SOURCES += main.cpp \
    networkaccessmanagerfactory.cpp \
    qmlapi.cpp

folder_symbian3.source = qml/stage1st
folder_symbian3.target = qml

DEPLOYMENTFOLDERS = folder_symbian3

symbian {
    contains(QT_VERSION, 4.7.3) {
        DEFINES += Q_OS_S60V5
        INCLUDEPATH += $$[QT_INSTALL_PREFIX]/epoc32/include/middleware
        INCLUDEPATH += $$[QT_INSTALL_PREFIX]/include/Qt
        MMP_RULES += "DEBUGGABLE"
    }

    CONFIG += qt-components
    TARGET.UID3 = 0xA006DFF6
    TARGET.CAPABILITY += NetworkServices ReadUserData WriteUserData

    vendorinfo = "%{\"Yeatse\"}" ":\"Yeatse\""
    my_deployment.pkg_prerules += vendorinfo
    DEPLOYMENT += my_deployment

    # Symbian have a different syntax
    DEFINES -= VER=\\\"$$VERSION\\\"
    DEFINES += VER=\"$$VERSION\"
}

# Please do not modify the following two lines. Required for deployment.
include(qmlapplicationviewer/qmlapplicationviewer.pri)
qtcAddDeployment()
