import QtQuick
import qs.services

Rectangle {
    id: sidebar

    // WIP: Will set based on Footer's height instead
    readonly property real footerHeightRatio: 0.075

    color: Theme.backgroundSecondary

    CardFooter {
        height: Math.round(parent.height * parent.footerHeightRatio)

        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
    }
}
