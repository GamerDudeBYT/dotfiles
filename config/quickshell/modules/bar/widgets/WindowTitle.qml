import QtQuick
import Quickshell.Hyprland
import "../../../"

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

    property string windowTitle: "Desktop"
    property var workspaceActiveWindow: ({})
    property bool isThisMonitorFocused: false

    function isWindowOnThisMonitor(address) {
        if (!monitor || !monitor.activeWorkspace) return false
        return monitor.activeWorkspace.toplevels.values.some(w => w.address === address)
    }

    function resolveTitle(address) {
        if (!monitor || !monitor.activeWorkspace) {
            windowTitle = "Desktop"
            return
        }
        const windows = monitor.activeWorkspace.toplevels.values
        if (address) {
            const target = windows.find(w => w.address === address)
            if (target) {
                windowTitle = target.title || "Desktop"
                return
            }
        }
        const localActive = monitor.activeWorkspace.activeWindow
        if (localActive) {
            windowTitle = localActive.title || "Desktop"
            return
        }
        if (windows && windows.length > 0) {
            windowTitle = windows[0].title || "Desktop"
            return
        }
        windowTitle = "Desktop"
    }

    function refreshFromCurrentWorkspace() {
        if (!monitor || !monitor.activeWorkspace) {
            windowTitle = "Desktop"
            return
        }
        const wsId = monitor.activeWorkspace.id
        const remembered = workspaceActiveWindow[wsId]
        if (remembered) {
            resolveTitle(remembered)
        } else {
            const active = monitor.activeWorkspace.activeWindow
            resolveTitle(active ? active.address : "")
        }
    }

    Component.onCompleted: {
        if (monitor) {
            isThisMonitorFocused = Hyprland.focusedMonitor
                ? Hyprland.focusedMonitor.name === monitor.name
                : false
        }
        refreshFromCurrentWorkspace()
    }

    Connections {
        target: monitor
        function onActiveWorkspaceChanged() {
            workspaceRefreshTimer.restart()
        }
    }

    Timer {
        id: workspaceRefreshTimer
        interval: 16
        repeat: false
        onTriggered: refreshFromCurrentWorkspace()
    }

    Connections {
        target: Hyprland
        function onRawEvent(event) {
            const name = event.name
            const data = event.data
            if (!data) return
            const args = data.split(",")

            if (name === "focusedmonv2") {
                isThisMonitorFocused = (monitor && monitor.name === args[0])
                if (isThisMonitorFocused) {
                    workspaceRefreshTimer.restart()
                }
            }

            if (name === "activewindowv2") {
                if (!isThisMonitorFocused || !isWindowOnThisMonitor(args[0])) return
                const addr = args[0]
                if (monitor.activeWorkspace) {
                    const wsId = monitor.activeWorkspace.id
                    const map = Object.assign({}, workspaceActiveWindow)
                    map[wsId] = addr
                    workspaceActiveWindow = map
                }
                resolveTitle(addr)
            }

            if (name === "windowtitlev2") {
                if (!monitor || !monitor.activeWorkspace) return
                const wsId = monitor.activeWorkspace.id
                const current = workspaceActiveWindow[wsId]
                if (args[0] === current) resolveTitle(args[0])
            }

            if (name === "workspacev2") {
                if (monitor && monitor.activeWorkspace &&
                    monitor.activeWorkspace.id === args[0]) {
                    workspaceRefreshTimer.restart()
                }
            }

            if (name === "closewindow") {
                const closed = args[0]
                const map = Object.assign({}, workspaceActiveWindow)
                for (const wsId in map) {
                    if (map[wsId] === closed) delete map[wsId]
                }
                workspaceActiveWindow = map
                workspaceRefreshTimer.restart()
            }

            if (name === "openwindow") {
                if (monitor && monitor.activeWorkspace &&
                    monitor.activeWorkspace.id === args[1]) {
                    workspaceRefreshTimer.restart()
                }
            }
        }
    }

    Text {
        id: titleLabel
        text: root.windowTitle
        anchors.centerIn: parent
        font.family: root.fontFamily
        font.pixelSize: 16
        color: Colors.md3.primary
        width: parent.width - parent.padH * 2
        elide: Text.ElideRight
    }
}
