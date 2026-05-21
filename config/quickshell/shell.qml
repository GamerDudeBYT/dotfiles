//@ pragma UseQApplication
import QtQuick
import Quickshell
import Quickshell.Wayland

import "./modules/bar/"

ShellRoot {
    id: root

    Loader {
        active: true
        sourceComponent: Bar {}
    }
}
