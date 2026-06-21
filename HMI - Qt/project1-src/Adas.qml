import QtQuick 2.15
import QtQuick3D 1.15
import "tesla_assets"

Item {
    id: root
    property color backgroundColor: "#0d1520"   // giữ API compat với Dashboard2.qml

    /* ── HC-SR04 proximity distance (cm). Set từ Dashboard2.qml ── */
    property int proximityDistance: 400

    /* Thresholds */
    readonly property int dangerCm:  30    /* < 30 cm  → DANGER (đỏ, nhanh) */
    readonly property int warningCm: 100   /* < 100 cm → WARNING (cam, chậm) */

    readonly property bool isDanger:  proximityDistance < dangerCm
    readonly property bool isWarning: proximityDistance >= dangerCm && proximityDistance < warningCm
    readonly property bool isAlert:   isDanger || isWarning

    /* ── Chế độ bầu trời. Toggle bởi nút ☀/🌙 ── */
    property bool isDaytime: false

    /* ── State machine xe vật cản ──────────────────────────────
       0 = hidden    : không có gì
       1 = approaching: sensor điều khiển z (tiến dần)
       2 = passing   : tách sensor, chạy vụt qua rồi mất
    ─────────────────────────────────────────────────────────── */
    property int obstaclePhase: 0

    onIsAlertChanged: {
        if (isAlert  && obstaclePhase === 0) obstaclePhase = 1
        if (!isAlert && obstaclePhase === 1) obstaclePhase = 0
    }

    onIsDangerChanged: {
        if (isDanger && obstaclePhase === 1) {
            obstaclePhase = 2
            passAnim.restart()       // tách sensor, chạy lên
        }
    }

    // ════════════════════════════════════════════════════════════
    //  BẦU TRỜI GRADIENT (2D – nằm sau View3D transparent)
    //  Hai layer cross-fade theo isDaytime
    // ════════════════════════════════════════════════════════════

    // ── Ban đêm ──
    Rectangle {
        anchors.fill: parent; z: -1
        opacity: root.isDaytime ? 0.0 : 1.0
        Behavior on opacity { NumberAnimation { duration: 1800 } }
        gradient: Gradient {
            orientation: Gradient.Vertical
            GradientStop { position: 0.00; color: "#0d1520" }
            GradientStop { position: 0.38; color: "#1c3a58" }
            GradientStop { position: 0.50; color: "#28403a" }
            GradientStop { position: 1.00; color: "#181818" }
        }
    }

    // ── Ban ngày ──
    Rectangle {
        anchors.fill: parent; z: -1
        opacity: root.isDaytime ? 1.0 : 0.0
        Behavior on opacity { NumberAnimation { duration: 1800 } }
        gradient: Gradient {
            orientation: Gradient.Vertical
            GradientStop { position: 0.00; color: "#5aaad8" }
            GradientStop { position: 0.38; color: "#a8d8ea" }
            GradientStop { position: 0.50; color: "#7a9068" }
            GradientStop { position: 1.00; color: "#3a3a3a" }
        }
    }

    // ════════════════════════════════════════════════════════════
    //  3D SCENE
    // ════════════════════════════════════════════════════════════
    View3D {
        anchors.fill: parent

        environment: SceneEnvironment {
            // Transparent → gradient 2D phía sau hiện ra làm bầu trời
            clearColor: "transparent"
            backgroundMode: SceneEnvironment.Transparent
        }

        // ── Ánh sáng chính (thay đổi theo ngày/đêm) ──
        DirectionalLight {
            eulerRotation.x: root.isDaytime ? -55 : -40
            eulerRotation.y: 20
            ambientColor: root.isDaytime
                ? Qt.rgba(0.90, 0.85, 0.72, 1.0)   // nắng ấm ban ngày
                : Qt.rgba(0.55, 0.60, 0.70, 1.0)   // ánh trăng/đêm
            brightness: root.isDaytime ? 3.2 : 2.2
            castsShadow: false
        }
        // ── Ánh fill nhẹ ──
        DirectionalLight {
            eulerRotation.x: 20
            eulerRotation.y: -160
            ambientColor: root.isDaytime
                ? Qt.rgba(0.35, 0.40, 0.35, 1.0)   // phản xạ mặt đất ngày
                : Qt.rgba(0.18, 0.22, 0.30, 1.0)   // fill đêm
            brightness: root.isDaytime ? 1.0 : 0.6
            castsShadow: false
        }

        // ── CAMERA ──────────────────────────────────────────────
        //  Nhìn từ sau xe, hơi cao, nghiêng xuống nhìn đường phía trước
        //  (giống góc nhìn trong ảnh tham chiếu)
        PerspectiveCamera {
            id: camera
            x: -20   // lệch nhẹ theo xe (xe ở x=-50)
            y: 260   // đủ cao để thấy đường dài phía trước
            z: 540   // lùi xa, cho phối cảnh chiều sâu rõ
            eulerRotation.x: -24  // nghiêng xuống rõ hơn
        }

        // ════════════════════════════════════════════════════════
        //  MẶT ĐƯỜNG 3 LÀN + LỀ ĐẤT
        // ════════════════════════════════════════════════════════
        Node {
            id: roadGroup
            y: 5

            // Lề đất hai bên (rộng 4000 units)
            Model {
                source: "#Rectangle"
                eulerRotation.x: -90
                scale: Qt.vector3d(40, 100, 1)
                z: -3000
                materials: PrincipledMaterial {
                    baseColor: "#2c2e28"
                    roughness: 1.0
                    lighting: PrincipledMaterial.NoLighting
                }
            }

            // Mặt đường asphalt chính (3 làn ≈ 300 units)
            Model {
                source: "#Rectangle"
                eulerRotation.x: -90
                scale: Qt.vector3d(3, 100, 1)
                z: -3000
                materials: PrincipledMaterial {
                    baseColor: "#484848"
                    metalness: 0.0
                    roughness: 1.0
                }
            }

            // ── Vạch kẻ làn TRÁI (x = -100) – cuộn vô hạn bằng modulo ──
            // Mỗi vạch tự tính vị trí qua modulo phase → không có reset toàn cục.
            // Điểm "nhảy" (z=450) nằm SAU camera (z=330) nên vĩnh viễn vô hình.
            Node {
                id: laneLeft
                x: -100
                property real phase: 0
                NumberAnimation on phase {
                    from: 0; to: 300; duration: 360
                    easing.type: Easing.Linear
                    loops: Animation.Infinite; running: true
                }
                Repeater3D {
                    model: 16
                    Model {
                        source: "#Rectangle"; eulerRotation.x: -90
                        scale: Qt.vector3d(0.08, 1.2, 1)
                        y: 2
                        z: {
                            var span = 16 * 300
                            var v = (index * 300 - laneLeft.phase) % span
                            if (v < 0) v += span
                            return 700 - v
                        }
                        materials: PrincipledMaterial {
                            baseColor: "#CCCCCC"
                            lighting: PrincipledMaterial.NoLighting
                        }
                    }
                }
            }

            // ── Vạch kẻ làn GIỮA (x = 0) – vàng – cuộn vô hạn bằng modulo ──
            Node {
                id: movingLines
                property real phase: 0
                NumberAnimation on phase {
                    from: 0; to: 300; duration: 360
                    easing.type: Easing.Linear
                    loops: Animation.Infinite; running: true
                }
                Repeater3D {
                    model: 16
                    Model {
                        source: "#Rectangle"; eulerRotation.x: -90
                        scale: Qt.vector3d(0.12, 1.5, 1)
                        y: 2
                        z: {
                            var span = 16 * 300
                            var v = (index * 300 - movingLines.phase) % span
                            if (v < 0) v += span
                            return 700 - v
                        }
                        materials: PrincipledMaterial {
                            baseColor: "#FFD700"
                            lighting: PrincipledMaterial.NoLighting
                        }
                    }
                }
            }

            // ── Vạch kẻ làn PHẢI (x = +100) – cuộn vô hạn bằng modulo ──
            Node {
                id: laneRight
                x: 100
                property real phase: 0
                NumberAnimation on phase {
                    from: 0; to: 300; duration: 360
                    easing.type: Easing.Linear
                    loops: Animation.Infinite; running: true
                }
                Repeater3D {
                    model: 16
                    Model {
                        source: "#Rectangle"; eulerRotation.x: -90
                        scale: Qt.vector3d(0.08, 1.2, 1)
                        y: 2
                        z: {
                            var span = 16 * 300
                            var v = (index * 300 - laneRight.phase) % span
                            if (v < 0) v += span
                            return 700 - v
                        }
                        materials: PrincipledMaterial {
                            baseColor: "#CCCCCC"
                            lighting: PrincipledMaterial.NoLighting
                        }
                    }
                }
            }

            // ── Viền mép đường TRÁI (trắng liên tục) ──
            Model {
                source: "#Rectangle"; eulerRotation.x: -90
                x: -150; y: 2
                scale: Qt.vector3d(0.06, 100, 1); z: -3000
                materials: PrincipledMaterial {
                    baseColor: "#AAAAAA"; lighting: PrincipledMaterial.NoLighting
                }
            }
            // ── Viền mép đường PHẢI (trắng liên tục) ──
            Model {
                source: "#Rectangle"; eulerRotation.x: -90
                x: 150; y: 2
                scale: Qt.vector3d(0.06, 100, 1); z: -3000
                materials: PrincipledMaterial {
                    baseColor: "#AAAAAA"; lighting: PrincipledMaterial.NoLighting
                }
            }
        }

        // ════════════════════════════════════════════════════════
        //  AUTOPILOT BLUE PATH
        //  Luồng xanh cyan ở làn ego – thu hẹp về phía chân trời
        // ════════════════════════════════════════════════════════
        Node {
            id: bluePathGroup
            x: root.obstaclePhase === 2 ? 70 : -50
            Behavior on x { NumberAnimation { duration: 700; easing.type: Easing.InOutQuad } }
            y: 8

            // Outer soft glow (rộng, trong suốt)
            Model {
                source: "#Rectangle"
                eulerRotation.x: -90
                scale: Qt.vector3d(0.72, 50, 1)
                z: -2500
                materials: PrincipledMaterial {
                    baseColor: "#4402AAFF"
                    alphaMode: PrincipledMaterial.Blend
                    lighting: PrincipledMaterial.NoLighting
                }
            }
            // Inner bright core (hẹp, sáng)
            Model {
                source: "#Rectangle"
                eulerRotation.x: -90
                scale: Qt.vector3d(0.30, 50, 1)
                z: -2500
                materials: PrincipledMaterial {
                    baseColor: "#BB00DFFF"
                    alphaMode: PrincipledMaterial.Blend
                    lighting: PrincipledMaterial.NoLighting
                }
            }
            // Center highlight (rất hẹp, cực sáng)
            Model {
                source: "#Rectangle"
                eulerRotation.x: -90
                scale: Qt.vector3d(0.10, 50, 1)
                z: -2500
                materials: PrincipledMaterial {
                    baseColor: "#EE80FFFF"
                    alphaMode: PrincipledMaterial.Blend
                    lighting: PrincipledMaterial.NoLighting
                }
            }
        }

        // ════════════════════════════════════════════════════════
        //  TÒA NHÀ BÊN TRÁI
        //  Node.y = 5 (mặt đường), Cube.y = height/2 → đứng trên nền
        // ════════════════════════════════════════════════════════
        Node { x: -285; y: 5; z:  -680
            Model { source: "#Cube"; scale: Qt.vector3d(0.90, 3.5, 0.90); y: 175
                materials: PrincipledMaterial { baseColor: "#3d4252"; roughness: 0.9 } } }
        Node { x: -375; y: 5; z: -1000
            Model { source: "#Cube"; scale: Qt.vector3d(1.10, 5.2, 1.00); y: 260
                materials: PrincipledMaterial { baseColor: "#464d5c"; roughness: 0.8 } } }
        Node { x: -248; y: 5; z: -1380
            Model { source: "#Cube"; scale: Qt.vector3d(0.80, 2.8, 0.80); y: 140
                materials: PrincipledMaterial { baseColor: "#353a47"; roughness: 0.9 } } }
        Node { x: -328; y: 5; z: -1760
            Model { source: "#Cube"; scale: Qt.vector3d(1.20, 4.8, 1.00); y: 240
                materials: PrincipledMaterial { baseColor: "#3f4555"; roughness: 0.8 } } }
        Node { x: -262; y: 5; z: -2260
            Model { source: "#Cube"; scale: Qt.vector3d(0.90, 6.2, 0.90); y: 310
                materials: PrincipledMaterial { baseColor: "#4a5060"; roughness: 0.7 } } }
        Node { x: -425; y: 5; z: -2880
            Model { source: "#Cube"; scale: Qt.vector3d(1.60, 8.5, 1.30); y: 425
                materials: PrincipledMaterial { baseColor: "#3d4252"; roughness: 0.8 } } }

        // ════════════════════════════════════════════════════════
        //  TÒA NHÀ BÊN PHẢI
        // ════════════════════════════════════════════════════════
        Node { x:  298; y: 5; z:  -600
            Model { source: "#Cube"; scale: Qt.vector3d(1.00, 4.2, 1.00); y: 210
                materials: PrincipledMaterial { baseColor: "#455060"; roughness: 0.9 } } }
        Node { x:  385; y: 5; z:  -890
            Model { source: "#Cube"; scale: Qt.vector3d(1.20, 5.8, 1.10); y: 290
                materials: PrincipledMaterial { baseColor: "#4a5565"; roughness: 0.8 } } }
        Node { x:  258; y: 5; z: -1260
            Model { source: "#Cube"; scale: Qt.vector3d(0.80, 3.2, 0.80); y: 160
                materials: PrincipledMaterial { baseColor: "#3d4550"; roughness: 0.9 } } }
        Node { x:  342; y: 5; z: -1700
            Model { source: "#Cube"; scale: Qt.vector3d(1.10, 4.8, 1.00); y: 240
                materials: PrincipledMaterial { baseColor: "#404858"; roughness: 0.8 } } }
        Node { x:  278; y: 5; z: -2180
            Model { source: "#Cube"; scale: Qt.vector3d(0.90, 5.8, 0.90); y: 290
                materials: PrincipledMaterial { baseColor: "#4a5568"; roughness: 0.7 } } }
        Node { x:  435; y: 5; z: -2780
            Model { source: "#Cube"; scale: Qt.vector3d(1.50, 7.5, 1.40); y: 375
                materials: PrincipledMaterial { baseColor: "#3d4258"; roughness: 0.8 } } }

        // ════════════════════════════════════════════════════════
        //  XE CHÍNH
        //  Bình thường: đứng yên làn trái (x = -50)
        //  Phase 2 (obstacle đang vụt qua): né sang làn phải (x = 70)
        //  Phase kết thúc: trở về làn cũ tự động
        // ════════════════════════════════════════════════════════
        Scene {
            id: myModel
            scale: Qt.vector3d(0.3, 0.3, 0.3)
            y: 35

            x: root.obstaclePhase === 2 ? 70 : -50
            Behavior on x {
                NumberAnimation { duration: 700; easing.type: Easing.InOutQuad }
            }

            eulerRotation.y: root.obstaclePhase === 2 ? -7 : 0
            Behavior on eulerRotation.y {
                NumberAnimation { duration: 400; easing.type: Easing.InOutQuad }
            }
        }

        // ════════════════════════════════════════════════════════
        //  VÙNG CẢM BIẾN PHÍA SAU – giữ nguyên 100%
        // ════════════════════════════════════════════════════════
        Node {
            id: rearDetectionZone
            visible: root.isAlert
            x: myModel.x
            y: 6
            z: 120

            SequentialAnimation on opacity {
                loops: Animation.Infinite
                NumberAnimation { from: 0.3; to: 0.8; duration: 800; easing.type: Easing.InOutSine }
                NumberAnimation { from: 0.8; to: 0.3; duration: 800; easing.type: Easing.InOutSine }
            }

            Model {
                source: "#Rectangle"
                eulerRotation.x: -90
                scale: Qt.vector3d(0.6, 1.2, 1)
                materials: PrincipledMaterial {
                    baseColor: root.isAlert
                               ? (root.isDanger ? "#66FF3B30" : "#66FF9500")
                               : "#660044FF"
                    alphaMode: PrincipledMaterial.Blend
                    lighting: PrincipledMaterial.NoLighting
                }
                Behavior on materials { }
            }
            Model {
                source: "#Rectangle"; eulerRotation.x: -90; x: -30
                scale: Qt.vector3d(0.04, 1.2, 1)
                materials: PrincipledMaterial {
                    baseColor: root.isDanger ? "#FFFF3B30" : "#FFFF3300"
                    lighting: PrincipledMaterial.NoLighting
                }
            }
            Model {
                source: "#Rectangle"; eulerRotation.x: -90; x: 30
                scale: Qt.vector3d(0.04, 1.2, 1)
                materials: PrincipledMaterial {
                    baseColor: root.isDanger ? "#FFFF3B30" : "#FFFF3300"
                    lighting: PrincipledMaterial.NoLighting
                }
            }
        }

        // ════════════════════════════════════════════════════════
        //  XE NPC PHÍA TRƯỚC – chạy liên tục về phía trước (−Z)
        //  Mỗi xe bắt đầu ở pha khác nhau → không bao giờ đồng bộ
        //  Xe vật cản từ sau sẽ không đuổi kịp (NPC luôn tiến xa hơn)
        // ════════════════════════════════════════════════════════

        // NPC 1 — làn trái (cùng làn ego), bắt đầu gần nhất
        Scene {
            id: npcCar1
            scale: Qt.vector3d(0.3, 0.3, 0.3)
            y: 35; x: -50
            eulerRotation.y: 180
            NumberAnimation on z {
                from: -350; to: -4200
                duration: 11000
                loops: Animation.Infinite
                running: true
                easing.type: Easing.Linear
            }
        }

        // NPC 2 — làn phải, pha lệch ~2 s
        Scene {
            id: npcCar2
            scale: Qt.vector3d(0.3, 0.3, 0.3)
            y: 35; x: 65
            eulerRotation.y: 180
            NumberAnimation on z {
                from: -580; to: -4200
                duration: 9800
                loops: Animation.Infinite
                running: true
                easing.type: Easing.Linear
            }
        }

        // NPC 3 — làn trái, xa nhất lúc đầu, pha lệch ~4 s
        Scene {
            id: npcCar3
            scale: Qt.vector3d(0.3, 0.3, 0.3)
            y: 35; x: -50
            eulerRotation.y: 180
            NumberAnimation on z {
                from: -920; to: -4200
                duration: 9200
                loops: Animation.Infinite
                running: true
                easing.type: Easing.Linear
            }
        }

        // ════════════════════════════════════════════════════════
        //  XE VẬT CẢN
        //
        //  Phase 1 – Approaching:
        //    z bị điều khiển bởi Binding bên dưới (sensor → z)
        //    Xe tiến dần khi khoảng cách giảm
        //
        //  Phase 2 – Passing:
        //    Binding tắt, passAnim lấy quyền điều khiển z
        //    Xe vụt lên phía trước (z → -900) rồi biến mất
        // ════════════════════════════════════════════════════════
        Scene {
            id: obstacleCar
            scale: Qt.vector3d(0.3, 0.3, 0.3)
            y: 35
            x: -50        // làn trái, không bám myModel khi xe chính né
            z: 580        // vị trí mặc định khi ẩn

            opacity: root.obstaclePhase > 0 ? 1.0 : 0.0
            Behavior on opacity { NumberAnimation { duration: 350 } }
        }

        // Phase 1: z = f(proximityDistance) – tắt khi phase != 1
        Binding {
            target: obstacleCar
            property: "z"
            value: 130 + Math.min(root.proximityDistance, root.warningCm)
                       / root.warningCm * 450
            when: root.obstaclePhase === 1
            // Binding tắt khi phase = 2 → giải phóng z cho passAnim
        }

        // Phase 2: xe vụt qua – from tự lấy z hiện tại khi start
        NumberAnimation {
            id: passAnim
            target: obstacleCar
            property: "z"
            to: -900
            duration: 1400
            easing.type: Easing.InQuad   // tăng tốc khi qua mặt
            onStopped: {
                if (root.obstaclePhase === 2)
                    root.obstaclePhase = 0   // reset: xe biến mất, xe chính về làn
            }
        }

    }  // end View3D

    // ════════════════════════════════════════════════════════════
    //  PROXIMITY WARNING OVERLAY  (HC-SR04) – giữ nguyên 100%
    // ════════════════════════════════════════════════════════════

    /* ── Viền nhấp nháy cảnh báo ── */
    Rectangle {
        id: alertBorder
        anchors.fill: parent
        color: "transparent"
        visible: root.isAlert
        border.color: root.isDanger ? "#FF3B30" : "#FF9500"
        border.width: 4
        opacity: borderPulse.value
        z: 10

        NumberAnimation on opacity {
            id: borderPulse
            property real value: 1.0
            running: root.isAlert
            loops: Animation.Infinite
            from: 1.0
            to: 0.15
            duration: root.isDanger ? 180 : 500
            easing.type: Easing.InOutSine
        }
    }

    /* ── Panel cảnh báo chính (góc dưới giữa) ── */
    Rectangle {
        id: warningPanel
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: 14
        width: 220; height: 90; radius: 10
        color: "#DD000000"
        border.color: root.isDanger ? "#FF3B30" : "#FF9500"
        border.width: 2
        visible: root.isAlert
        z: 11

        SequentialAnimation on opacity {
            running: root.isAlert; loops: Animation.Infinite
            NumberAnimation { from: 1.0; to: 0.6; duration: root.isDanger ? 180 : 500 }
            NumberAnimation { from: 0.6; to: 1.0; duration: root.isDanger ? 180 : 500 }
        }

        Column {
            anchors.centerIn: parent; spacing: 5
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "⚠"; font.pixelSize: 28
                color: root.isDanger ? "#FF3B30" : "#FF9500"
            }
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: root.proximityDistance + " cm"
                font.pixelSize: 18; font.bold: true; color: "#FFFFFF"
            }
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: root.isDanger ? "NGUY HIỂM!" : "CẢNH BÁO"
                font.pixelSize: 11; font.letterSpacing: 2
                color: root.isDanger ? "#FF3B30" : "#FF9500"
            }
        }
    }

    /* ── Radar sweep mini (góc dưới phải) ── */
    Item {
        id: radarMini
        width: 80; height: 80
        anchors.right: parent.right; anchors.bottom: parent.bottom
        anchors.margins: 12
        visible: root.isAlert; z: 11

        Rectangle {
            anchors.fill: parent; radius: 40
            color: "#AA000000"
            border.color: root.isDanger ? "#FF3B30" : "#FF9500"
            border.width: 1
        }
        Repeater {
            model: 3
            Rectangle {
                property real factor: (index + 1) / 3.0
                width: parent.width * factor; height: parent.height * factor
                anchors.centerIn: parent; radius: width / 2
                color: "transparent"
                border.color: root.isDanger ? "#55FF3B30" : "#5501E6DE"
                border.width: 1
            }
        }
        Rectangle {
            id: objectDot
            width: root.isDanger ? 10 : 7; height: width; radius: width / 2
            color: root.isDanger ? "#FF3B30" : "#FF9500"
            anchors.centerIn: parent
            property real normalised: Math.min(root.proximityDistance / root.warningCm, 1.0)
            transform: Translate {
                y: -(objectDot.parent.height / 2 - 6) * (1.0 - objectDot.normalised)
            }
            SequentialAnimation on opacity {
                running: root.isAlert; loops: Animation.Infinite
                NumberAnimation { from: 1.0; to: 0.2; duration: root.isDanger ? 200 : 600 }
                NumberAnimation { from: 0.2; to: 1.0; duration: root.isDanger ? 200 : 600 }
            }
        }
        Text {
            anchors.bottom: parent.bottom; anchors.horizontalCenter: parent.horizontalCenter
            text: "REAR"; font.pixelSize: 8; font.letterSpacing: 1
            color: "#8801E6DE"
        }
    }

    // ════════════════════════════════════════════════════════════
    //  NÚT TOGGLE NGÀY / ĐÊM  (góc trên phải)
    // ════════════════════════════════════════════════════════════
    Rectangle {
        id: skyToggleBtn
        anchors.top:   parent.top
        anchors.right: parent.right
        anchors.margins: 12
        width: 78; height: 34; radius: 17
        z: 12

        color: root.isDaytime ? "#1565a8" : "#0d1a30"
        border.color: root.isDaytime ? "#FFD700" : "#3a5a88"
        border.width: 1
        Behavior on color { ColorAnimation { duration: 600 } }

        Row {
            anchors.centerIn: parent
            spacing: 6

            Text {
                text: root.isDaytime ? "☀" : "🌙"
                font.pixelSize: 15
                color: root.isDaytime ? "#FFD700" : "#88aadd"
                anchors.verticalCenter: parent.verticalCenter
            }
            Text {
                text: root.isDaytime ? "DAY" : "NIGHT"
                font.pixelSize: 10
                font.bold: true
                font.letterSpacing: 1
                color: root.isDaytime ? "#ffffff" : "#7799bb"
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: root.isDaytime = !root.isDaytime
        }
    }
}
