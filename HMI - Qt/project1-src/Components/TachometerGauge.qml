/****************************************************************************
** TachometerGauge.qml
** Đồng hồ RPM — vùng đỏ 6500+, hiển thị số gear ở tâm
****************************************************************************/

import QtQuick 2.9
import QtGraphicalEffects 1.12

Item {
    id: root

    width:  380
    height: 380

    property real rpm:      0.0   // 0 → 8000
    property real maxRpm:   8000
    property real redline:  6500
    property int  gear:     0     // -1 R, 0 N, 1-8 D

    // ── outer ring ───────────────────────────────────────────────────────
    Rectangle {
        anchors.centerIn: parent
        width: 360; height: 360; radius: 180
        color: "transparent"
        border.width: 3
        border.color: rpm > redline ? Qt.rgba(1,.1,.1,.9) : Qt.rgba(1,.4,.2,.7)

        Behavior on border.color { ColorAnimation { duration: 250 } }

        layer.enabled: true
        layer.effect: Glow {
            samples: 24; radius: 12
            color:   rpm > redline ? "#ff1744" : "#ff6d00"
            spread:  0.2
        }
    }

    // ── dark inner face ──────────────────────────────────────────────────
    Rectangle {
        anchors.centerIn: parent
        width: 340; height: 340; radius: 170
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#1a0a00" }
            GradientStop { position: 1.0; color: "#1c0e00" }
        }
    }

    // ── arcs + ticks ─────────────────────────────────────────────────────
    Canvas {
        id: arc
        anchors.fill: parent
        antialiasing: true

        property real ratio: Math.min(rpm / maxRpm, 1.0)

        onRatioChanged: requestPaint()
        Behavior on ratio {
            NumberAnimation { duration: 200; easing.type: Easing.OutQuad }
        }

        onPaint: {
            var ctx = getContext("2d")
            ctx.clearRect(0, 0, width, height)

            var cx = width / 2, cy = height / 2
            var R  = 152
            var a0 = 0.75 * Math.PI
            var a1 = 2.25 * Math.PI
            var aRed = a0 + (a1 - a0) * (redline / maxRpm)
            var ap   = a0 + (a1 - a0) * ratio

            // background
            ctx.beginPath()
            ctx.arc(cx, cy, R, a0, a1)
            ctx.lineWidth   = 10
            ctx.strokeStyle = "rgba(255,255,255,0.07)"
            ctx.lineCap     = "round"
            ctx.stroke()

            // orange zone
            if (ratio > 0) {
                var endOrange = Math.min(ap, aRed)
                if (endOrange > a0) {
                    var go = ctx.createLinearGradient(0, 0, width, 0)
                    go.addColorStop(0, "#ff6d00"); go.addColorStop(1, "#ffab00")
                    ctx.beginPath()
                    ctx.arc(cx, cy, R, a0, endOrange)
                    ctx.lineWidth = 10; ctx.strokeStyle = go; ctx.lineCap = "round"
                    ctx.stroke()
                }
            }

            // red zone
            if (ratio > redline / maxRpm) {
                var gr = ctx.createLinearGradient(0, 0, width, 0)
                gr.addColorStop(0, "#ff1744"); gr.addColorStop(1, "#d50000")
                ctx.beginPath()
                ctx.arc(cx, cy, R, aRed, ap)
                ctx.lineWidth = 10; ctx.strokeStyle = gr; ctx.lineCap = "round"
                ctx.stroke()
            }

            // tick marks (every 500 RPM)
            for (var i = 0; i <= 16; i++) {
                var ta    = a0 + (a1 - a0) * (i / 16)
                var big   = (i % 2 === 0)
                var isRed = (i * 500 >= redline)
                ctx.beginPath()
                ctx.moveTo(cx + (big ? 130 : 138) * Math.cos(ta), cy + (big ? 130 : 138) * Math.sin(ta))
                ctx.lineTo(cx + 148 * Math.cos(ta), cy + 148 * Math.sin(ta))
                ctx.lineWidth   = big ? 2.5 : 1.5
                ctx.strokeStyle = isRed ? "rgba(255,80,80,.9)" : "rgba(220,160,100,.7)"
                ctx.stroke()
            }

            // labels (every 1000 RPM)
            for (var j = 0; j <= 8; j++) {
                var la = a0 + (a1 - a0) * (j / 8)
                var lx = cx + 112 * Math.cos(la)
                var ly = cy + 112 * Math.sin(la)
                ctx.font         = "bold 16px Arial"
                ctx.fillStyle    = j >= 7 ? "rgba(255,80,80,.9)" : "rgba(220,160,100,.85)"
                ctx.textAlign    = "center"
                ctx.textBaseline = "middle"
                ctx.fillText(j, lx, ly)
            }

            // "x1000 RPM" label
            ctx.font      = "12px Arial"
            ctx.fillStyle = "rgba(180,140,100,.7)"
            ctx.textAlign = "center"
            ctx.fillText("× 1000 RPM", cx, cy + 80)
        }
    }

    // ── needle ───────────────────────────────────────────────────────────
    Item {
        anchors.centerIn: parent
        width: 10; height: 200

        rotation: 135 + Math.min(rpm / maxRpm, 1.0) * 270
        Behavior on rotation {
            NumberAnimation { duration: 200; easing.type: Easing.OutQuad }
        }

        Rectangle {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.verticalCenter
            width: 5; height: 130; radius: 2.5
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#ff6d00" }
                GradientStop { position: 1.0; color: "#7f2000" }
            }
            layer.enabled: true
            layer.effect: DropShadow { radius: 6; samples: 13; color: "#80000000" }
        }
        Rectangle {
            anchors.centerIn: parent
            width: 18; height: 18; radius: 9
            color: "#ff6d00"; border.width: 2; border.color: "#331000"
        }
    }

    // ── gear + RPM readout ───────────────────────────────────────────────
    Column {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter:   parent.verticalCenter
        anchors.verticalCenterOffset: 35
        spacing: 4

        // Gear label
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: {
                if (gear === -1) return "R"
                if (gear === 0)  return "N"
                if (gear > 0)    return "D" + gear
                return "P"
            }
            font { pixelSize: 48; bold: true; family: "Arial" }
            color: gear === -1 ? "#ff5252" : gear === 0 ? "#ffab00" : "#69f0ae"
            style: Text.Outline; styleColor: "#1a0800"
            Behavior on color { ColorAnimation { duration: 200 } }
            layer.enabled: true
            layer.effect: Glow { samples: 15; color: parent.color; spread: 0.4 }
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: Math.round(rpm) + " rpm"
            font { pixelSize: 14; family: "Arial" }
            color: rpm > redline ? "#ff5252" : Qt.rgba(220/255, 160/255, 100/255, 0.8)
            Behavior on color { ColorAnimation { duration: 200 } }
        }
    }

    // ── redline strobe ───────────────────────────────────────────────────
    SequentialAnimation {
        running: rpm > redline
        loops: Animation.Infinite
        PropertyAnimation { target: root; property: "opacity"; to: 0.75; duration: 250 }
        PropertyAnimation { target: root; property: "opacity"; to: 1.0;  duration: 250 }
    }
}
