import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import qs.components

PanelWindow {
    id: root

    property real reveal: shown ? 1 : 0

    // Set below the screen if false, revealed if true
    property bool shown: false
    readonly property real cardWidthRatio: 0.6
    readonly property real cardHeightRatio: 0.65

    color: "transparent"
    exclusionMode: ExclusionMode.Ignore

    // Exclusive while shown; None when hidden releases the keyboard
    WlrLayershell.keyboardFocus: root.shown ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None
    // Overlay keeps the surface above other layer-shell surfaces
    WlrLayershell.layer: WlrLayer.Overlay

    Behavior on reveal {
        NumberAnimation {
            duration: 200
            easing.type: Easing.InOutQuad
        }
    }
    mask: Region {
        id: inputRegion

        item: root.shown ? backdrop : card
        topLeftRadius: root.shown ? 0 : card.radius
        topRightRadius: root.shown ? 0 : card.radius
    }

    onShownChanged: {
        if (inputRegion)
            inputRegion.changed();

        if (shown) {
            Qt.callLater(() => {
                card.wallpaperGrid.forceActiveFocus();
            });
        }
    }

    // Full-screen input while shown so outside clicks dismiss the widget
    MouseArea {
        id: backdrop

        anchors.fill: parent
        enabled: root.shown
        acceptedButtons: Qt.AllButtons

        onClicked: widgetIpcHandler.hideWidget()
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

        // Hide/close the widget when ESC key is pressed
        Keys.onEscapePressed: {
            widgetIpcHandler.hideWidget();
        }
    }

    // Trigger from a keybind: quickshell ipc -c bbeetlehop call bbeetlehop toggleWidget
    // WIP: Needs more adjustments
    IpcHandler {
        id: widgetIpcHandler

        function hideWidget(): void {
            root.shown = false;
        }

        function showWidget(): void {
            root.shown = true;
        }

        function toggleWidget(): void {
            root.shown = !root.shown;
        }

        target: "bbeetlehop"
    }
}
