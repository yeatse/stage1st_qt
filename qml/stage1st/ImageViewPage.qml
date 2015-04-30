import QtQuick 1.1
import com.nokia.symbian 1.1

Page {
    id: page

    property url imageUrl

    tools: ToolBarLayout {
        ToolButton {
            iconSource: "toolbar-back"
            platformInverted: true
            onClicked: pageStack.pop()
        }
        ToolButton {
            iconSource: "internet_inverted.svg"
            platformInverted: true
        }
    }

    Rectangle {
        anchors.fill: parent
        color: platformStyle.colorBackground
    }

    Flickable {
        id: imageFlickable
        anchors.fill: parent
        contentWidth: imageContainer.width; contentHeight: imageContainer.height
        clip: true
        onHeightChanged: if (imagePreview.status == Loader.Ready && imagePreview.item.status == Image.Ready)
                             imagePreview.fitToScreen()

        Item {
            id: imageContainer
            width: Math.max(imagePreview.width * imagePreview.scale, imageFlickable.width)
            height: Math.max(imagePreview.height * imagePreview.scale, imageFlickable.height)

            Loader {
                id: imagePreview

                property real prevScale

                function fitToScreen() {
                    scale = Math.min(imageFlickable.width / width, imageFlickable.height / height, 1)
                    pinchArea.minScale = scale
                    prevScale = scale
                }

                anchors.centerIn: parent

                sourceComponent: imageUrl.toString().indexOf(".gif") > 0 ? animatedImage : stillImage

                onScaleChanged: {
                    if ((width * scale) > imageFlickable.width) {
                        var xoff = (imageFlickable.width / 2 + imageFlickable.contentX) * scale / prevScale
                        imageFlickable.contentX = xoff - imageFlickable.width / 2
                    }
                    if ((height * scale) > imageFlickable.height) {
                        var yoff = (imageFlickable.height / 2 + imageFlickable.contentY) * scale / prevScale
                        imageFlickable.contentY = yoff - imageFlickable.height / 2
                    }
                    prevScale = scale
                }

                NumberAnimation {
                    id: loadedAnimation
                    target: imagePreview
                    property: "opacity"
                    duration: 250
                    from: 0; to: 1
                    easing.type: Easing.InOutQuad
                }

                Component {
                    id: stillImage
                    Image {
                        cache: false
                        asynchronous: true
                        source: imageUrl
                        sourceSize.height: 1000
                        smooth: !imageFlickable.moving

                        onStatusChanged: {
                            if (status == Image.Ready) {
                                imagePreview.fitToScreen()
                                loadedAnimation.start()
                            }
                        }
                    }
                }

                Component {
                    id: animatedImage
                    AnimatedImage {
                    }
                }
            }
        }

        PinchArea {
            id: pinchArea

            property real minScale: 1.0
            property real maxScale: 3.0

            anchors.fill: parent
            enabled: imagePreview.status == Loader.Ready && imagePreview.item.status == Image.Ready
            pinch.target: imagePreview
            pinch.minimumScale: minScale * 0.5 // This is to create "bounce back effect"
            pinch.maximumScale: maxScale * 1.5 // when over zoomed

            onPinchFinished: {
                imageFlickable.returnToBounds()
                if (imagePreview.scale < pinchArea.minScale) {
                    bounceBackAnimation.to = pinchArea.minScale
                    bounceBackAnimation.start()
                }
                else if (imagePreview.scale > pinchArea.maxScale) {
                    bounceBackAnimation.to = pinchArea.maxScale
                    bounceBackAnimation.start()
                }
            }

            NumberAnimation {
                id: bounceBackAnimation
                target: imagePreview
                duration: 250
                property: "scale"
                from: imagePreview.scale
            }
        }
        MouseArea {
            id: mouseArea
            anchors.fill: parent
            enabled: imagePreview.status == Loader.Ready && imagePreview.item.status == Image.Ready
            onDoubleClicked: {
                if (imagePreview.scale > pinchArea.minScale){
                    bounceBackAnimation.to = pinchArea.minScale
                    bounceBackAnimation.start()
                } else {
                    bounceBackAnimation.to = pinchArea.maxScale
                    bounceBackAnimation.start()
                }
            }
        }
    }

    Loader {
        anchors.centerIn: parent
        sourceComponent: {
            if (imagePreview.status != Loader.Ready)
                return undefined

            switch (imagePreview.item.status) {
            case Image.Loading:
                return loadingIndicator
            case Image.Error:
                return failedLoading
            default:
                return undefined
            }
        }

        Component {
            id: loadingIndicator

            Item {
                height: childrenRect.height
                width: page.width

                BusyIndicator {
                    id: imageLoadingIndicator
                    anchors.horizontalCenter: parent.horizontalCenter
                    height: platformStyle.graphicSizeLarge; width: platformStyle.graphicSizeLarge
                    running: true
                }

                Text {
                    anchors {
                        horizontalCenter: parent.horizontalCenter
                        top: imageLoadingIndicator.bottom; topMargin: platformStyle.paddingLarge
                    }
                    font.pixelSize: platformStyle.fontSizeLarge
                    color: platformStyle.colorNormalLight
                    text: "正在加载...%1".arg(Math.round(imagePreview.item.progress) + "%")
                }
            }
        }

        Component {
            id: failedLoading
            Text {
                font.pixelSize: platformStyle.fontSizeLarge
                color: platformStyle.colorNormalLight
                text: "图片加载失败"
            }
        }
    }

    ScrollDecorator { flickableItem: imageFlickable }
}
