pragma Singleton

import QtQuick
import Quickshell.Io
import Qt.labs.folderlistmodel
import Qt.labs.platform

// Owns wallpaper discovery, awww integration, and the current selection state
QtObject {
    id: root

    // Default wallpaper folder: $XDG_PICTURES_DIR/Wallpapers
    // WIP: Make it overridable by the user's external config file
    readonly property url defaultFolder: StandardPaths.writableLocation(StandardPaths.PicturesLocation) + "/Wallpapers"
    property url folder: defaultFolder

    readonly property list<string> nameFilters: ["*.png", "*.jpg", "*.jpeg", "*.webp", "*.gif"]
    readonly property FolderListModel model: FolderListModel {
        folder: root.folder
        nameFilters: root.nameFilters
        showDirs: false
        sortField: FolderListModel.Name
    }

    property string currentPath: ""
    property string pendingPath: ""

    // WIP: Make it overridable by the user's external config file
    property string transitionType: "center"
    property string transitionDuration: "1.25"

    readonly property bool transitioning: transitionTimer.running
    readonly property int transitionHoldMs: {
        const seconds = Number(transitionDuration);
        return transitionType === "none" || !isFinite(seconds) || seconds <= 0 ?
            0 : Math.round(seconds * 1000) + 75;
    }

    readonly property Process applyProcess: Process {}
    readonly property Timer transitionTimer: Timer {
        interval: root.transitionHoldMs

        onTriggered: {
            if (root.pendingPath !== "") {
                root.currentPath = root.pendingPath;
                root.pendingPath = "";
            }
        }
    }

    // Highlight the wallpaper awww is already displaying
    readonly property Process queryProcess: Process {
        command: ["awww", "query"]
        running: true

        stdout: SplitParser {
            onRead: line => {
                const marker = "currently displaying: image: ";
                const index = line.indexOf(marker);

                // Only seed the selection when nothing has been chosen yet
                if (index !== -1 && root.currentPath === "" && root.pendingPath === "")
                    root.currentPath = line.substring(index + marker.length).trim();
            }
        }
    }

    function apply(path) {
        // Ignore clicks while transitioning
        if (transitioning || path === currentPath)
            return;

        currentPath = "";
        pendingPath = path;

        // Calls `awww img` command to change the wallpaper
        applyProcess.exec([
            "awww", "img", path,
            "-t", transitionType,
            "--transition-duration", transitionDuration
        ]);

        if (transitionHoldMs > 0) {
            transitionTimer.restart();
        } else {
            currentPath = path;
            pendingPath = "";
        }
    }
}
