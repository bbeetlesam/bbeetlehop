import QtQuick
import qs.services

// Bottom (footer) section of WidgetCard
Rectangle {
    id: footer

    // WIP: for debugging
    // Later will be replaced to display the actual username in the session
    property string usernameText: "samudra"

    color: Theme.backgroundSecondary

    // Acts as a top border
    Rectangle {
        height: Metrics.borderWidth
        color: Theme.border

        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }
    }
    Rectangle {
        width: parent.width
        height: username.implicitHeight
        color: "transparent"
        anchors.verticalCenter: parent.verticalCenter

        Text {
            id: username

            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            text: footer.usernameText
            color: Theme.textDefault
            font.family: Theme.fontFamily
            font.pixelSize: 20
            font.weight: Font.DemiBold
            clip: true
        }
    }
}
