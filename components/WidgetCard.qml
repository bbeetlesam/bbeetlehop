import QtQuick
import qs.services

Rectangle {
    id: card

    property string title: "Bienvenue, Camomile"
    property string subtitle: "We'll talk about it later."

    // WIP: all values are currently hardcoded
    width: 700
    height: 250
    radius: 15
    bottomLeftRadius: 0
    bottomRightRadius: 0
    color: Theme.background
    border.width: 2
    border.color: Theme.border

    Column {
        anchors.centerIn: parent
        width: parent.width
        spacing: 12

        Text {
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            text: card.title
            color: Theme.accent
            font.family: "Akt"
            font.pixelSize: 30
            font.weight: Font.DemiBold
            clip: true
        }
        Text {
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            text: card.subtitle
            color: Theme.text
            font.family: "Akt"
            font.pixelSize: 15
            font.weight: Font.Normal
            clip: true
        }
    }
}
