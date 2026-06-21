/****************************************************************************
** SpeedometerGauge.qml
** Đồng hồ tốc độ tròn — vẽ bằng Canvas + needle
** Dùng bởi VehicleICDashboard.qml
****************************************************************************/

import QtQuick 2.9
import QtGraphicalEffects 1.12

Item {
    id: root

    width:  380
    height: 380

    property real speed:    0.0   // km/h, 0 → 260
    property real maxSpeed: 260

    // ── outer glow ring ──────────────────────────────────────────────────
    Rectangle {
        anchors.centerIn: parent
        width: 360; height: 360; radius: 180
        color: "transparent"
        border.width: 3
        border.color: Qt.rgba(0.2, 0.6, 1.0, 0.7)

        layer.enabled: true
        layer.effect: Glow {
            samples: 24; radius: 12
            color:   Qt.rgba(0.2, 0.6, 1.0, 0.9)
            spread:  0.2
        }
    }

    // ── dark inner face ──────────────────────────────────────────────────
    Rectangle {
        anchors.centerIn: parent
        width: 340; height: 340; radius: 170
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#0d1b2a" }
            GradientStop { position: 1.0; color: "#111c28" }
        }
    }

    // ── arc + tick marks ─────────────────────────────────────────────────
    Canvas {
        id: arc
        anchors.fill: parent
        antialiasing: true

        property real ratio: Math.min(speed / maxSpeed, 1.0)

        onRatioChanged: requestPaint()

        Behavior on ratio {
            NumberAnimation { duration: 300; easing.type: Easing.OutCubic }
        }

        onPaint: {
            var ctx  = getContext("2d")
            ctx.clearRect(0, 0, width, height)

            var cx = width / 2, cy = height / 2
            var R  = 152
            // arc: 135° → 405° (270° span)
            var a0 = 0.75 * Math.PI
            var a1 = 2.25 * Math.PI
            var ap = a0 + (a1 - a0) * ratio

            // background track
            ctx.beginPath()
            ctx.arc(cx, cy, R, a0, a1)
            ctx.lineWidth   = 10
            ctx.strokeStyle = "rgba(255,255,255,0.08)"
            ctx.lineCap     = "round"
            ctx.stroke()

            // coloured progress
            if (ratio > 0) {
                var g = ctx.createLinearGradient(0, 0, width, 0)
                if (ratio < 0.6) {
                    g.addColorStop(0, "#00e676"); g.addColorStop(1, "#00c853")
                } else if (ratio < 0.85) {
                    g.addColorStop(0, "#ffab00"); g.addColorStop(1, "#ff6d00")
                } else {
                    g.addColorStop(0, "#ff1744"); g.addColorStop(1, "#d50000")
                }
                ctx.beginPath()
                ctx.arc(cx, cy, R, a0, ap)
                ctx.lineWidth   = 10
                ctx.strokeStyle = g
                ctx.lineCap     = "round"
                ctx.stroke()
            }

            // tick marks every 10 km/h, labels every 50 km/h
            for (var i = 0; i <= 26; i++) {
                var tickAngle = a0 + (a1 - a0) * (i / 26)
                var big = (i % 5 === 0)
                var r0  = big ? 132 : 138
                var r1  = 148

                ctx.beginPath()
                ctx.moveTo(cx + r0 * Math.cos(tickAngle), cy + r0 * Math.sin(tickAngle))
                ctx.lineTo(cx + r1 * Math.cos(tickAngle), cy + r1 * Math.sin(tickAngle))
                ctx.lineWidth   = big ? 2.5 : 1.5
                ctx.strokeStyle = big ? "rgba(200,220,255,0.85)" : "rgba(150,180,210,0.4)"
                ctx.stroke()
            }

            // speed labels
            for (var j = 0; j <= 26; j += 5) {
                var labelAngle = a0 + (a1 - a0) * (j / 26)
                var lr = 116
                var lx = cx + lr * Math.cos(labelAngle)
                var ly = cy + lr * Math.sin(labelAngle)
                ctx.font         = "bold 14px Arial"
                ctx.fillStyle    = "rgba(180,210,240,0.85)"
                ctx.textAlign    = "center"
                ctx.textBaseline = "middle"
                ctx.fillText(j * 10, lx, ly)
            }
        }
    }

    // ── needle ───────────────────────────────────────────────────────────
    Item {
        anchors.centerIn: parent
        width: 10; height: 200

        rotation: 135 + Math.min(speed / maxSpeed, 1.0) * 270
        Behavior on rotation {
            NumberAnimation { duration: 350; easing.type: Easing.OutCubic }
        }

        Rectangle {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.verticalCenter
            width: 5; height: 130; radius: 2.5
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#ff5252" }
                GradientStop { position: 1.0; color: "#7f0000" }
            }
            layer.enabled: true
            layer.effect: DropShadow { radius: 6; samples: 13; color: "#80000000" }
        }

        // cap
        Rectangle {
            anchors.centerIn: parent
            width: 18; height: 18; radius: 9
            color: "#ff5252"
            border.width: 2; border.color: "#330000"
        }
    }

    // ── digital readout ──────────────────────────────────────────────────
    Column {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter:   parent.verticalCenter
        anchors.verticalCenterOffset: 40
        spacing: 4

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: Math.round(speed)
            font { pixelSize: 52; bold: true; family: "Arial" }
            color: {
                if (speed < maxSpeed * 0.6)  return "#00e676"
                if (speed < maxSpeed * 0.85) return "#ffab00"
                return "#ff1744"
            }
            style: Text.Outline; styleColor: "#1a1a2e"

            Behavior on color { ColorAnimation { duration: 300 } }
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "km/h"
            font { pixelSize: 14; family: "Arial" }
            color: Qt.rgba(150/255, 180/255, 220/255, 0.8)
        }
    }
}
