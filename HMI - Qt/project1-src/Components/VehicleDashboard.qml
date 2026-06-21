import QtQuick 2.9
import QtQuick.Controls 2.2

Item {
    id: root

    property var store

    // ── Vehicle 2D Panel (scaled to fit) ──────────────────────────────────
    Vehicle2DPanel {
        id: panel

        property real scaleX: root.width  / 1920
        property real scaleY: root.height / 652
        property real s:      Math.min(scaleX, scaleY)

        scale:           s
        transformOrigin: Item.Center
        anchors.centerIn: parent

        trunkOpen:     store ? store.trunkOpened            : false
        leftDoorOpen:  store ? store.leftDoorOpened         : false
        rightDoorOpen: store ? store.rightDoorOpened        : false
        roofOpen:      store ? store.roofOpenProgress > 0.0 : false
        speed:         store ? store.speed                  : 0.0
    }

    // ── Control Panel overlay (góc phải trên) ─────────────────────────────
    Rectangle {
        anchors.right:   parent.right
        anchors.top:     parent.top
        anchors.margins: 20
        width:  220
        height: controlCol.implicitHeight + 30
        color:  "#CC1e1e1e"
        radius: 10
        border.width: 1
        border.color: "#44ffffff"

        Column {
            id: controlCol
            anchors {
                left:    parent.left
                right:   parent.right
                top:     parent.top
                margins: 15
            }
            spacing: 8

            Text {
                text: "Vehicle Controls"
                color: "white"
                font.bold: true
                font.pixelSize: 14
            }

            // ── Doors ──
            ControlBtn {
                label:  "Left Door"
                active: store ? store.leftDoorOpened : false
                onToggle: {
                    if (store) store.leftDoorOpened = !store.leftDoorOpened
                    if (canHandler.leftDoorIndex >= 0)
                        canHandler.sendOutputCommand(canHandler.leftDoorIndex,
                            store.leftDoorOpened ? 1 : 0, 0)
                }
            }
            ControlBtn {
                label:  "Right Door"
                active: store ? store.rightDoorOpened : false
                onToggle: {
                    if (store) store.rightDoorOpened = !store.rightDoorOpened
                    if (canHandler.rightDoorIndex >= 0)
                        canHandler.sendOutputCommand(canHandler.rightDoorIndex,
                            store.rightDoorOpened ? 1 : 0, 0)
                }
            }
            ControlBtn {
                label:  "Trunk"
                active: store ? store.trunkOpened : false
                onToggle: if (store) store.trunkOpened = !store.trunkOpened
            }
            ControlBtn {
                label:  "Roof"
                active: store ? store.roofOpenProgress === 1.0 : false
                onToggle: if (store) store.roofOpenProgress = (store.roofOpenProgress === 1.0) ? 0.0 : 1.0
            }

            // ── Speed ──
            Rectangle {
                width: parent.width; height: 1
                color: "#44ffffff"
            }

            Text {
                text: "Speed: " + (store ? store.speed.toFixed(0) : "0") + " km/h"
                color: "#aaaaaa"
                font.pixelSize: 12
            }

            Slider {
                width: parent.width
                from: 0; to: 200
                value: store ? store.speed : 0
                onMoved: if (store) store.speed = value
            }
        }
    }

    // ── Reusable toggle button ─────────────────────────────────────────────
    component ControlBtn: Rectangle {
        property string label:  ""
        property bool   active: false
        signal toggle()
        width:  parent.width
        height: 34
        radius: 6
        color:  active ? "#2a5298" : "#333333"
        border.width: 1
        border.color: active ? "#5b8de8" : "#555555"

        Behavior on color        { ColorAnimation { duration: 150 } }
        Behavior on border.color { ColorAnimation { duration: 150 } }

        Text {
            anchors.centerIn: parent
            text:  (active ? "✓  " : "      ") + label
            color: active ? "#ffffff" : "#aaaaaa"
            font.pixelSize: 13
            Behavior on color { ColorAnimation { duration: 150 } }
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked:  parent.toggle()
            onPressed:  parent.scale = 0.95
            onReleased: parent.scale = 1.0
        }
        Behavior on scale { NumberAnimation { duration: 80 } }
    }
}
