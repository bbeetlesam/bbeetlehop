import QtQuick
import qs.services

// Main (body) section of WidgetCard
Rectangle {
    id: body

    property string title: "Bienvenue, Camomile"
    property string subtitle: "We'll talk about it later."

    color: "transparent"

    Column {
        anchors.centerIn: parent
        width: parent.width
        spacing: 12

        Text {
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            text: body.title
            color: Theme.accent
            font.family: Theme.fontFamily
            font.pixelSize: 30
            font.weight: Font.DemiBold
            clip: true
        }
        Text {
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            text: body.subtitle
            color: Theme.text
            font.family: Theme.fontFamily
            font.pixelSize: 15
            font.weight: Font.Normal
            clip: true
        }
    }
}
