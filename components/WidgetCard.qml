import QtQuick
import qs.services

// Main container of Card
Rectangle {
    id: card

    readonly property real radiusRatio: 0.025
    readonly property real footerHeightRatio: 0.075

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
    CardBody {
        // Matches the Card's radius and border width to avoid clipping
        topLeftRadius: Math.max(0, card.radius - card.border.width)
        topRightRadius: Math.max(0, card.radius - card.border.width)

        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            bottom: footer.top
            topMargin: card.border.width
            leftMargin: card.border.width
            rightMargin: card.border.width
        }
    }
    CardFooter {
        id: footer

        height: Math.round(card.height * card.footerHeightRatio)

        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            leftMargin: card.border.width
            rightMargin: card.border.width
        }
    }
}
