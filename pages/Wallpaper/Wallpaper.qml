pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Window
import qs.services
import qs.pages.Wallpaper

// Wallpaper selection page
FocusScope {
    id: page

    // Shown as this page's name in the sidebar
    readonly property string pageTitle: "Wallpaper"

    property int gap: 10
    property int targetCellWidth: 200

    readonly property int columns: Math.max(1, Math.floor(width / targetCellWidth))
    readonly property real cellWidth: width / columns
    readonly property real cellHeight: Math.round((cellWidth - gap) / tileAspectRatio + gap)
    readonly property real tileAspectRatio:
        Screen.height > 0 ? Screen.width / Screen.height : 16 / 9

    // Keyboard-highlighted tile path; "" when nothing is highlighted
    readonly property string selectedPath: {
        const index = grid.currentIndex;

        if (!grid.activeFocus || index < 0 || index >= Wallpapers.model.count)
            return "";

        const path = Wallpapers.model.get(index, "filePath");
        return typeof path === "string" ? path : "";
    }

    // Enter approval — same gates as mouse activation
    function confirmSelection() {
        if (selectedPath !== "")
            Wallpapers.apply(selectedPath);
    }

    GridView {
        id: grid

        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            topMargin: 24
            leftMargin: 24
            rightMargin: 24
            bottomMargin: 24
        }
        boundsBehavior: Flickable.StopAtBounds
        cellHeight: page.cellHeight
        cellWidth: page.cellWidth
        clip: true
        // Holds keyboard focus once the window hands focus to this page
        focus: true
        // Arrow navigation is handled explicitly below
        keyNavigationEnabled: false
        model: Wallpapers.model

        delegate: Item {
            id: tile

            required property int index
            required property string filePath
            required property url fileUrl

            height: grid.cellHeight
            width: grid.cellWidth

            WallpaperItem {
                anchors.fill: parent
                anchors.margins: page.gap / 2
                current: Wallpapers.currentPath === tile.filePath
                pending: Wallpapers.pendingPath === tile.filePath
                selected: grid.activeFocus && tile.GridView.isCurrentItem
                source: tile.fileUrl

                onActivated: Wallpapers.apply(tile.filePath)
            }
        }

        // Other keys are not consumed, so Escape bubbles to the card
        Keys.onPressed: event => {
            switch (event.key) {
            case Qt.Key_Left:
                grid.moveCurrentIndexLeft();
                break;
            case Qt.Key_Right:
                grid.moveCurrentIndexRight();
                break;
            case Qt.Key_Up:
                grid.moveCurrentIndexUp();
                break;
            case Qt.Key_Down:
                grid.moveCurrentIndexDown();
                break;
            default:
                return;
            }
            grid.positionViewAtIndex(grid.currentIndex, GridView.Contain);
            event.accepted = true;
        }

        // Return and keypad-Enter approve the highlighted tile
        Keys.onReturnPressed: page.confirmSelection()
        Keys.onEnterPressed: page.confirmSelection()
    }

    // Thin scroll indicator in the right side
    Rectangle {
        id: scrollbar

        visible: grid.contentHeight > grid.height
        x: page.width - width
        y: grid.visibleArea.yPosition * page.height
        width: 3
        height: Math.max(24, grid.visibleArea.heightRatio * page.height)
        radius: width / 2
        color: Theme.border
    }
}
