//@ pragma UseQApplication
import QtQuick
import Quickshell
import Quickshell.Wayland
import "./modules/bar/"

ShellRoot {
    id: root
    Variants {
        model: Quickshell.screens
        delegate: Bar {}
    }
}
