import QtQuick 2.9

QtObject {
    id: root

    property bool leftDoorOpened:   false
    property bool rightDoorOpened:  false
    property bool trunkOpened:      false
    property real roofOpenProgress: 0.0
    property real speed:            0.0
}
