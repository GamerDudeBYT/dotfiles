pragma Singleton
import QtQuick

QtObject {
    property var md3: ({
    <* for name, value in colors *>
        {{ name }}: "{{ value.default.hex }}",
    <* endfor *>
    })

}
