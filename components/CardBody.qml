import QtQuick
import qs.services

// Main (body) section of WidgetCard
Rectangle {
    id: body

    property string title: "Wallpaper Selection"

    // Exposed so the window can give the grid keyboard focus on show
    readonly property alias wallpaperGrid: gallery

    color: "transparent"

    Column {
        id: heading

        width: parent.width
        topPadding: 15
        bottomPadding: 15

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
        id: gallery

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
