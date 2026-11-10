pragma ComponentBehavior: Bound

import QtQuick
import qs.services

// Left column of WidgetCard
Rectangle {
    id: sidebar

    // WIP: Page index is decorative until page switching exists
    property list<string> pageTitles: []
    property string currentPage: ""

    // WIP: Will set based on Footer's height instead
    readonly property real footerHeightRatio: 0.075

    color: Theme.backgroundSecondary

    // Page list, filled from the instantiated pages
    Column {
        id: pageList

        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            topMargin: 20
            leftMargin: 20
            rightMargin: 20
        }
        spacing: 12

        Repeater {
            model: sidebar.pageTitles

            Text {
                required property string modelData

                width: parent.width
                text: modelData
                color: modelData === sidebar.currentPage ? Theme.textAccent : Theme.textDefault
                font.family: Theme.fontFamily
                font.pixelSize: 18
                font.weight: modelData === sidebar.currentPage ? Font.DemiBold : Font.Normal
                elide: Text.ElideRight
            }
        }
    }

    SidebarFooter {
        height: Math.round(parent.height * parent.footerHeightRatio)

        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
    }
}
