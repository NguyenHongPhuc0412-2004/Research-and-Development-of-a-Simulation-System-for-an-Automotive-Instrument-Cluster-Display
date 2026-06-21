import QtQuick 2.9
import QtGraphicalEffects 1.12

Item {
    id: root

    height: 652
    width: 1920

    property bool trunkOpen:     false
    property bool leftDoorOpen:  false
    property bool rightDoorOpen: false
    property bool roofOpen:      false
    property real speed:         0.0

    SequentialAnimation {
        running: speed > 0.0 && (trunkOpen || leftDoorOpen || roofOpen || rightDoorOpen)
        loops: Animation.Infinite
        PropertyAnimation {
            targets: [sunroofAlarm, trunkAlarm, leftDooralarm, rightDooralarm]
            properties: "opacity"
            from: 0.0; to: 1.0; duration: 1000
        }
        PropertyAnimation {
            targets: [sunroofAlarm, trunkAlarm, leftDooralarm, rightDooralarm]
            properties: "opacity"
            from: 1.0; to: 0.0; duration: 1000
        }
    }

    Image {
        anchors.topMargin: -68
        anchors.fill: parent
        source: "qrc:/assets/images/ic_background.png"
    }

    Item {
        anchors.top: parent.top; anchors.topMargin: -300
        anchors.left: parent.left; anchors.leftMargin: 670
        width: 400; height: 500
        RadialGradient {
            anchors.fill: parent
            horizontalRadius: parent.width * .8
            verticalRadius:   parent.height * .8
            angle: -20
            gradient: Gradient {
                GradientStop { position: 0.0; color: "white" }
                GradientStop { position: 0.6; color: "transparent" }
            }
        }
    }

    Item {
        anchors.top: parent.top; anchors.topMargin: -300
        anchors.right: parent.right; anchors.rightMargin: 670
        width: 400; height: 500
        RadialGradient {
            anchors.fill: parent
            horizontalRadius: parent.width * .8
            verticalRadius:   parent.height * .8
            angle: 20
            gradient: Gradient {
                GradientStop { position: 0.0; color: "white" }
                GradientStop { position: 0.6; color: "transparent" }
            }
        }
    }

    Image {
        id: base
        anchors.fill: parent
        source: "qrc:/assets/images/ic_bodyVehicle.png"
    }

    Image {
        anchors.fill: parent
        source: "qrc:/assets/images/ic_roofClosedVehicle.png"
        visible: sunroofOpened.opacity !== 1.0
    }

    Image {
        id: sunroofOpened
        anchors.fill: parent
        source: "qrc:/assets/images/ic_roofOpenedVehicle.png"
        opacity: root.roofOpen ? 1.0 : 0.0
        Behavior on opacity { NumberAnimation { duration: 300 } }
    }

    Image {
        id: sunroofAlarm
        anchors.fill: parent
        source: "qrc:/assets/images/ic_roofAlarmVehicle.png"
        visible: roofOpen && root.speed > 0
    }

    Image {
        id: leftDoor
        anchors.fill: parent
        source: "qrc:/assets/images/ic_leftDoorClosedVehicle.png"
        visible: !root.leftDoorOpen
    }

    Image {
        id: leftDoorOpenedCarPart
        anchors.fill: parent
        source: "qrc:/assets/images/ic_leftDoorOpenedVehicleCarPart.png"
        visible: root.leftDoorOpen
    }

    Image {
        id: leftDoorOpened
        anchors.fill: parent
        source: "qrc:/assets/images/ic_leftDoorOpenedVehicle.png"
        opacity: root.leftDoorOpen ? 1.0 : 0.0
        Behavior on opacity { NumberAnimation { duration: 300 } }
    }

    Image {
        id: leftDooralarm
        anchors.fill: parent
        source: "qrc:/assets/images/ic_leftDoorAlarmVehicle.png"
        visible: leftDoorOpen && root.speed > 0
    }

    Image {
        id: rightDoor
        anchors.fill: parent
        source: "qrc:/assets/images/ic_rightDoorClosedVehicle.png"
        visible: !root.rightDoorOpen
    }

    Image {
        id: rightDoorOpenedCarPart
        anchors.fill: parent
        source: "qrc:/assets/images/ic_rightDoorOpenedVehicleCarPart.png"
        visible: root.rightDoorOpen
    }

    Image {
        id: rightDoorOpened
        anchors.fill: parent
        source: "qrc:/assets/images/ic_rightDoorOpenedVehicle.png"
        opacity: root.rightDoorOpen ? 1.0 : 0.0
        Behavior on opacity { NumberAnimation { duration: 300 } }
    }

    Image {
        id: rightDooralarm
        anchors.fill: parent
        source: "qrc:/assets/images/ic_rightDoorAlarmVehicle.png"
        visible: rightDoorOpen && root.speed > 0
    }

    Image {
        id: trunk
        anchors.fill: parent
        source: "qrc:/assets/images/ic_trunkClosedVehicle.png"
        visible: trunkOpened.opacity !== 1.0
    }

    Image {
        id: trunkOpened
        anchors.fill: parent
        source: "qrc:/assets/images/ic_trunkOpenedVehicle.png"
        opacity: root.trunkOpen ? 1.0 : 0.0
        Behavior on opacity { NumberAnimation { duration: 300 } }
    }

    Image {
        id: trunkAlarm
        anchors.fill: parent
        source: "qrc:/assets/images/ic_trunkAlarmVehicle.png"
        visible: trunkOpen && root.speed > 0
    }
}
