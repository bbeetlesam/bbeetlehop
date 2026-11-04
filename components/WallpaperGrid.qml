pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Window
import qs.services

// Scrollable grid of wallpapers selection
Item {
    id: root

    property int gap: 10
    property int targetCellWidth: 200

    readonly property int columns: Math.max(1, Math.floor(width / targetCellWidth))
    readonly property real cellWidth: width / columns
    readonly property real cellHeight: Math.round((cellWidth - gap) / tileAspectRatio + gap)
    readonly property real tileAspectRatio:
        Screen.height > 0 ? Screen.width / Screen.height : 16 / 9

    GridView {
        id: grid

        anchors.fill: parent
        boundsBehavior: Flickable.StopAtBounds
        cellHeight: root.cellHeight
        cellWidth: root.cellWidth
        clip: true
        model: Wallpapers.model

        delegate: Item {
            id: tile

            required property string filePath
            required property url fileUrl

            height: grid.cellHeight
            width: grid.cellWidth

            WallpaperItem {
                anchors.fill: parent
                anchors.margins: root.gap / 2
                current: Wallpapers.currentPath === tile.filePath
                pending: Wallpapers.pendingPath === tile.filePath
                source: tile.fileUrl

                onActivated: Wallpapers.apply(tile.filePath)
            }
        }
    }

    // Thin scroll indicator in the right side
    Rectangle {
        id: scrollbar

        visible: grid.contentHeight > grid.height
        x: root.width - width
        y: grid.visibleArea.yPosition * root.height
        width: 3
        height: Math.max(24, grid.visibleArea.heightRatio * root.height)
        radius: width / 2
        color: Theme.border
    }
}
