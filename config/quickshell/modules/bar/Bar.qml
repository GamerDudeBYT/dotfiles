import QtQuick
import Quickshell
import Quickshell.Hyprland
import "../../"

PanelWindow {
    id: panel
    anchors {
        top: true
        left: true
        right: true
    }

    implicitHeight: 55

    margins {
        top: 0
        left: 0
        right: 0
    }

    Rectangle {
        id: bar
        anchors.fill: parent
        color: Colors.md3.background // background
        Rectangle {
            id: bottom_border
            height: 3
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            color: Colors.md3.outline_variant // outline-variant
        }
        Row {
            id: workspace_row
            anchors {
                left: parent.left
                verticalCenter: parent.verticalCenter
                leftMargin: 16
            }
            spacing: 1
            Repeater {
                model: Hyprland.workspaces // could just do 10 to show 10 workspaces (need to make it work for the other monitors)
                Rectangle {
                    width: 25
                    height: 55
                    color: modelData.active ? Colors.md3.on_secondary : modelData.focused ? "#64727d" : Colors.md3.background
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            Hyprland.dispatch("workspace " + modelData.id);
                        }
                    }
                    Text {
                        anchors.fill: parent
                        text: modelData.active ? "" : "" // Need to find a way to get the other properties that waybar has (not necessary but nice)
                        color: Colors.md3.secondary
                        font.pixelSize: 16
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    Rectangle {
                        height: 3
                        anchors.bottom: parent.bottom
                        anchors.left: parent.left
                        anchors.right: parent.right
                        color: Colors.md3.outline_variant // outline-variant
                    }
                }
            }
        }
    }
}
