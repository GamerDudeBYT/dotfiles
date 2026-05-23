import QtQuick
import Quickshell
import Quickshell.Hyprland
import "../../../"

Rectangle {
    width: 25
    height: 55

    property int wsId
    property string fontFamily

    property var ws: Hyprland.workspaces.values.find(w => w.id === wsId)
    property bool exists: ws !== undefined
    property bool isActive: ws?.active ?? false
    property bool isFocused: ws?.focused ?? false

    color: isFocused ? Colors.md3.on_secondary : Colors.md3.background

    MouseArea {
        anchors.fill: parent
        onClicked: {
            if (ws)
                ws.activate();
            else
                Quickshell.execDetached(["hyprctl", "dispatch", "hl.dsp.focus({workspace = " + wsId + "})"]);
        }
    }

    Text {
        anchors.centerIn: parent
        text: isFocused ? "" : isActive ? "" : exists ? "" : "-"
        color: Colors.md3.secondary
        font.pixelSize: 16
        font.bold: exists ? false : true
        font.family: parent.fontFamily
    }
}
