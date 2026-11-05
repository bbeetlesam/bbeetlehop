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

    // Trigger from a keybind: quickshell ipc -c bbeetlehop call bbeetlehop toggle
    // WIP: Needs more adjustments
    IpcHandler {
        function hideWidget(): void { // unused yet
            root.shown = false;
        }

        function showWidget(): void { // unused yet
            root.shown = true;
        }

        function toggleWidget(): void {
            root.shown = !root.shown;
        }

        target: "bbeetlehop"
    }
}
