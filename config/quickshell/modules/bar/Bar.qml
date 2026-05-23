import QtQuick
import Quickshell
import Quickshell.Hyprland
import "../../"
import "widgets"

PanelWindow {
    id: panel

    property string fontFamily: "Hurmit Nerd Font"

    property var modelData
    screen: modelData
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

    property var monitorIds: screen?.name === "DP-1" ? [1, 2, 3, 4, 5, 6, 7, 8, 9, 10] : screen?.name === "HDMI-A-2" ? [11, 12, 13, 14, 15] : []

    Rectangle {
        id: bar
        anchors.fill: parent
        color: Colors.md3.background

        // ── LEFT ────────────────────────────────────────────────
        Item {
            id: leftSection
            anchors {
                left: parent.left
                top: parent.top
                bottom: parent.bottom
            }
            width: childrenRect.width

            Row {
                anchors.verticalCenter: parent.verticalCenter
                spacing: 0

                DistroIcon {}

                // Workspace buttons
                Row {
                    spacing: 1
                    anchors.verticalCenter: parent.verticalCenter

                    Repeater {
                        model: panel.monitorIds

                        WorkspaceButton {
                            wsId: modelData
                            fontFamily: panel.fontFamily
                        }
                    }
                }
            }
        }

        // ── CENTER ──────────────────────────────────────────────
        Item {
            id: centerSection
            anchors {
                horizontalCenter: parent.horizontalCenter
                top: parent.top
                bottom: parent.bottom
            }
            width: centerContent.implicitWidth

            Row {
                id: centerContent
                anchors.centerIn: parent
                spacing: 8

                WindowTitle {
                    monitor: Hyprland.monitorFor(panel.screen)
                    fontFamily: panel.fontFamily
                    maxWidth: bar.width - leftSection.width - rightSection.width - 32
                }
            }
        }

        // ── RIGHT ────────────────────────────────────────────────
        Item {
            id: rightSection
            anchors {
                right: parent.right
                top: parent.top
                bottom: parent.bottom
            }
            width: rightContent.implicitWidth + 16

            Row {
                id: rightContent
                anchors {
                    right: parent.right
                    rightMargin: 16
                    verticalCenter: parent.verticalCenter
                }
                spacing: 8

                Text {
                    text: "Right"
                    color: Colors.md3.on_background
                    verticalAlignment: Text.AlignVCenter
                    anchors.verticalCenter: parent.verticalCenter
                }

                Network {
                    fontFamily: panel.fontFamily
                }
            }
        }

        // Bottom border for the whole bar
        Rectangle {
            height: 3
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            color: Colors.md3.outline_variant
        }
    }
}
