import QtQuick
import Quickshell
import Quickshell.Hyprland
import "../../../" // Assuming Colors is defined here

Rectangle {
    id: root
    required property string fontFamily
    required property var monitor

    property real padV: 5
    property real padH: 15
    property real maxWidth: 400

    width: Math.min(titleLabel.implicitWidth + padH * 2, maxWidth)
    height: titleLabel.implicitHeight + padV * 2
    color: Colors.md3.on_primary

    property string currentTitle: "Desktop"
    property string activeAddress: ""

    // THE FIX: Bringing back the workspace memory cache
    property var addressCache: ({})

    function isWindowOnThisWorkspace(address) {
        if (!monitor || !monitor.activeWorkspace)
            return false;
        const toplevels = monitor.activeWorkspace.toplevels.values;
        return toplevels.some(w => w.address === address);
    }

    function updateTitleFallback() {
        if (!monitor || !monitor.activeWorkspace) {
            currentTitle = "Desktop";
            activeAddress = "";
            return;
        }

        const wsId = monitor.activeWorkspace.id;
        const toplevels = monitor.activeWorkspace.toplevels.values;
        const cachedAddr = addressCache[wsId];

        // 1. Try the cached memory first (Fixes the switch-back bug)
        if (cachedAddr) {
            const target = toplevels.find(w => w.address === cachedAddr);
            if (target) {
                currentTitle = target.title || "Desktop";
                activeAddress = target.address;
                return;
            }
        }

        // 2. Try Quickshell's active window property
        const active = monitor.activeWorkspace.activeWindow;
        if (active && active.title) {
            currentTitle = active.title;
            activeAddress = active.address;

            // Save to cache (Object.assign forces QML to notice the update)
            const newCache = Object.assign({}, addressCache);
            newCache[wsId] = active.address;
            addressCache = newCache;
            return;
        }

        // 3. Fallback to first available window if no active window is found
        if (toplevels && toplevels.length > 0) {
            currentTitle = toplevels[0].title || "Desktop";
            activeAddress = toplevels[0].address;

            // Save fallback to cache
            const newCache = Object.assign({}, addressCache);
            newCache[wsId] = toplevels[0].address;
            addressCache = newCache;
        } else {
            currentTitle = "Desktop";
            activeAddress = "";
        }
    }

    Component.onCompleted: updateTitleFallback()

    Connections {
        target: monitor
        function onActiveWorkspaceChanged() {
            updateTitleFallback();
        }
    }

    Connections {
        target: monitor && monitor.activeWorkspace ? monitor.activeWorkspace.toplevels : null
        function onRowsInserted() {
            updateTitleFallback();
        }
        function onRowsRemoved() {
            updateTitleFallback();
        }
        function onDataChanged() {
            updateTitleFallback();
        }
    }

    Connections {
        target: Hyprland
        function onRawEvent(event) {
            const name = event.name;
            const data = event.data;
            if (!data)
                return;

            const args = data.split(",");

            if (name === "activewindowv2") {
                if (isWindowOnThisWorkspace(args[0])) {
                    activeAddress = args[0];

                    // Update cache for this workspace when a new window gets focused
                    if (monitor.activeWorkspace) {
                        const wsId = monitor.activeWorkspace.id;
                        const newCache = Object.assign({}, addressCache);
                        newCache[wsId] = args[0];
                        addressCache = newCache;
                    }

                    const target = monitor.activeWorkspace.toplevels.values.find(w => w.address === args[0]);
                    if (target)
                        currentTitle = target.title || "Desktop";
                }
            }

            if (name === "windowtitlev2") {
                if (isWindowOnThisWorkspace(args[0])) {
                    const target = monitor.activeWorkspace.toplevels.values.find(w => w.address === args[0]);
                    if (target)
                        currentTitle = target.title || "Desktop";
                }
            }
        }
    }

    Text {
        id: titleLabel
        text: root.currentTitle
        anchors.centerIn: parent
        font.family: root.fontFamily
        font.pixelSize: 16
        color: Colors.md3.primary
        width: parent.width - (root.padH * 2)
        elide: Text.ElideRight
        horizontalAlignment: Text.AlignHCenter
    }
}
