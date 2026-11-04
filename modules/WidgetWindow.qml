import QtQuick
import Quickshell
import Quickshell.Io
import qs.components

PanelWindow {
    id: root

    property real reveal: shown ? 1 : 0

    // Set below the screen if false, revealed if true
    property bool shown: false

    readonly property real cardWidthRatio: 0.5
    readonly property real cardHeightRatio: 0.7

    color: "transparent"
    exclusionMode: ExclusionMode.Ignore
    focusable: false

    Behavior on reveal {
        NumberAnimation {
            duration: 200
            easing.type: Easing.InOutQuad
        }
    }

    // Clicks outside the card are passed through
    mask: Region {
        id: inputRegion

        item: card
        topLeftRadius: card.radius
        topRightRadius: card.radius
    }

    anchors {
        bottom: true
        left: true
        right: true
        top: true
    }
    WidgetCard {
        id: card

        width: Math.round(root.width * root.cardWidthRatio)
        height: Math.round(root.height * root.cardHeightRatio)
        anchors.horizontalCenter: parent.horizontalCenter
        y: root.height - height * root.reveal

        onYChanged: if (inputRegion)
                        inputRegion.changed()
    }

    // Trigger from a keybind: quickshell ipc call widget toggle
    // WIP: Only for testing
    IpcHandler {
        function hide(): void {
            root.shown = false;
        }

        function show(): void {
            root.shown = true;
        }

        function toggle(): void {
            root.shown = !root.shown;
        }

        target: "widget"
    }
}
