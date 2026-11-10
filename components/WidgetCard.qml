import QtQuick
import qs.services

// Main container of Card
Rectangle {
    id: card

    readonly property real radiusRatio: 0.025
    readonly property real sidebarWidthRatio: 0.2

    // Where the window's on-show keyboard focus lands
    readonly property Item wallpaperGrid: body.wallpaperGrid

    radius: Math.round(width * radiusRatio)
    bottomLeftRadius: 0
    bottomRightRadius: 0
    color: Theme.background
    border.width: Metrics.borderWidth
    border.color: Theme.border

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.AllButtons
    }
    Sidebar {
        id: sidebar

        width: Math.round(card.width * card.sidebarWidthRatio)
        // Matches the Card's radius and border width to avoid clipping
        topLeftRadius: Math.max(0, card.radius - card.border.width)

        anchors {
            left: parent.left
            top: parent.top
            bottom: parent.bottom
            leftMargin: card.border.width
            topMargin: card.border.width
            bottomMargin: card.border.width
        }
    }
    CardBody {
        id: body

        // Matches the Card's radius and border width to avoid clipping
        topRightRadius: Math.max(0, card.radius - card.border.width)

        anchors {
            top: parent.top
            left: sidebar.right
            right: parent.right
            bottom: parent.bottom
            topMargin: card.border.width
            leftMargin: card.border.width
            rightMargin: card.border.width
            bottomMargin: card.border.width
        }
    }
}
