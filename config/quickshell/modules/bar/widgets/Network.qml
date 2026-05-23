import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Networking
import "../../../"

Rectangle {
    id: root

    required property string fontFamily

    property real padV: 5
    property real padH: 15
    property real maxWidth: 400

    property string textValue: "Loading..."

    color: Colors.md3.on_primary

    Text {
        id: label

        anchors.centerIn: parent

        text: root.textValue

        font.family: root.fontFamily
        font.pixelSize: 16
        color: Colors.md3.primary

        elide: Text.ElideRight

        width: implicitWidth
    }

    width: Math.min(label.implicitWidth + padH * 2, maxWidth)
    height: label.implicitHeight + padV * 2
}
