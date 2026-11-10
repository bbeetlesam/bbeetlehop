import QtQuick
import qs.pages.Wallpaper
import qs.services

// Main container of Card
Rectangle {
    id: card

    readonly property real radiusRatio: 0.025
    readonly property real sidebarWidthRatio: 0.2

    // The current page active in the card
    readonly property Item activePage: page

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
        topLeftRadius: Math.max(0, card.radius - card.border.width)

        // WIP: Decorative index filled from the instantiated page
        pageTitles: [page.pageTitle]
        currentPage: page.pageTitle

        anchors {
            left: parent.left
            top: parent.top
            bottom: parent.bottom
            leftMargin: card.border.width
            topMargin: card.border.width
            bottomMargin: card.border.width
        }
    }
    Wallpaper {
        id: page

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
