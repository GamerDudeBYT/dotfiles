import QtQuick
import "../../../"

Rectangle {
    x: 0
    y: 0
    clip: false
    width: 42
    height: 55
    color: Colors.md3.background

    Text {
        text: ""
        font.pixelSize: 20
        color: "white"
        anchors.fill: parent
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
}
