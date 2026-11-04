import QtQuick
import qs.services

// Main (body) section of WidgetCard
Rectangle {
    id: body

    property string title: "Wallpaper Selection"

    color: "transparent"

    Column {
        id: heading

        width: parent.width
        topPadding: 15
        bottomPadding: 15
        // spacing: 12

        anchors {
            top: parent.top
        }
        Text {
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            text: body.title
            color: Theme.textAccent
            font.family: Theme.fontFamily
            font.pixelSize: 25
            font.weight: Font.DemiBold
            clip: true
        }
    }
    WallpaperGrid {
        anchors {
            top: heading.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            leftMargin: 24
            rightMargin: 24
            bottomMargin: 24
        }
    }
}
