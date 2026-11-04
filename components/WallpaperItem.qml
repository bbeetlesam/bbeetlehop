import QtQuick
import qs.services

// Single wallpaper thumbnail tile
Rectangle {
    id: item

    property url source
    property bool current: false
    property bool pending: false

    signal activated

    color: Theme.backgroundSecondary
    border.width: Metrics.borderWidth
    border.color: pending ? Theme.pending : (current ? Theme.textAccent : Theme.border)
    clip: true

    Image {
        anchors.fill: parent
        anchors.margins: item.border.width
        asynchronous: true
        cache: true
        fillMode: Image.PreserveAspectCrop
        source: item.source
        sourceSize.height: Math.round(height)
        sourceSize.width: Math.round(width)
    }
    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor

        onClicked: item.activated()
    }
}
