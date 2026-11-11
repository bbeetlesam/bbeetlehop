import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import qs.components
import qs.pages.Wallpaper

PanelWindow {
    id: root

    property real reveal: shown ? 1 : 0

    // Starts false so the reveal animates in and onShownChanged hands focus over
    property bool shown: false
    // Set when hiding; the instance quits once it is fully hidden
    property bool pendingQuit: false
    readonly property real cardWidthRatio: 0.6
    readonly property real cardHeightRatio: 0.65
    readonly property real slideDuration: 150

    // Quit only after the hide animation and any pending wallpaper transition
    function maybeQuit() {
        if (pendingQuit && !Wallpapers.transitioning && reveal === 0)
            Qt.quit();
    }

    color: "transparent"
    exclusionMode: ExclusionMode.Ignore

    // Exclusive while shown; None when hidden releases the keyboard
    WlrLayershell.keyboardFocus: root.shown ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None
    // Overlay keeps the surface above other layer-shell surfaces
    WlrLayershell.layer: WlrLayer.Overlay

    Behavior on reveal {
        NumberAnimation {
            duration: root.slideDuration
            easing.type: Easing.InOutQuad
        }
    }
    mask: Region {
        id: inputRegion

        item: root.shown ? backdrop : card
        topLeftRadius: root.shown ? 0 : card.radius
        topRightRadius: root.shown ? 0 : card.radius
    }

    // Spawned instances show themselves; starting hidden lets the reveal animate
    Component.onCompleted: root.shown = true
    onShownChanged: {
        if (inputRegion)
            inputRegion.changed();

        if (shown) {
            Qt.callLater(() => {
                card.activePage.forceActiveFocus();
            });
        }
    }
    // Reveal animates through 0 exactly when the hide animation finishes
    onRevealChanged: maybeQuit()

    // The transition hold ends after a wallpaper application completes
    Connections {
        function onTransitioningChanged() {
            root.maybeQuit();
        }

        target: Wallpapers
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

    // Trigger from Quickshell's IPC
    IpcHandler {
        id: widgetIpcHandler

        function hideWidget(): void {
            root.shown = false;
            root.pendingQuit = true;
            root.maybeQuit();
        }

        function showWidget(): void {
            root.pendingQuit = false;
            root.shown = true;
        }

        target: "bbeetlehop"
    }
}
