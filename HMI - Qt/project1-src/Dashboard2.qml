import QtQuick 2.12
import CustomControls 1.0
import QtQuick.Window 2.12
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.5
import QtGraphicalEffects 1.0
import "./"

Item {
    id: root
    width: 1920
    height: 1125

    // =============================================
    // PROPERTIES & FUNCTIONS
    // =============================================
    property int nextSpeed: 60
    property bool isCrashed: false
    property bool hazardOn: false   // trạng thái nháy hazard nội bộ (Dashboard2 không có icon xi nhan)
    property int ultrasonicDistance: 400
    property int distanceValue: 188
    property int fuelValue: 34
    property int avgSpeedValue: 78
    property string rtcTimeStr: "--:--:--"
    property string rtcDateStr: "--/--/----"
    property bool   rtcValid:   false
    property var    dowNames: ["", "Chủ nhật", "Thứ 2", "Thứ 3", "Thứ 4",
                               "Thứ 5", "Thứ 6", "Thứ 7"]   // quy ước 1=CN
    property string rtcDowStr: ""

    // Góc lái chuẩn hoá từ potentiometer vô-lăng: -1 (hết trái) … 0 (thẳng) … +1 (hết phải)
    property real steeringNorm: 0
    // Uốn cong mượt + vẽ lại vạch mỗi khi góc lái đổi
    Behavior on steeringNorm { NumberAnimation { duration: 120; easing.type: Easing.OutQuad } }
    onSteeringNormChanged: parkingLinesCanvas.requestPaint()


    Behavior on distanceValue { NumberAnimation { duration: 1000; easing.type: Easing.OutQuad } }
    Behavior on fuelValue     { NumberAnimation { duration: 1000; easing.type: Easing.OutQuad } }
    Behavior on avgSpeedValue { NumberAnimation { duration: 1000; easing.type: Easing.OutQuad } }

    function generateRandom(maxLimit) {
        maxLimit = maxLimit || 70
        return Math.floor(Math.random() * maxLimit)
    }

    function speedColor(value) {
        if (value < 60)  return "green"
        else if (value < 150) return "yellow"
        else return "Red"
    }

    Timer {
        interval: 3000; running: true; repeat: true
        onTriggered: nextSpeed = generateRandom()
    }
    Timer {
        interval: 5000; running: true; repeat: true
        onTriggered: {
            distanceValue = Math.floor(Math.random() * 100) + 150
            fuelValue     = Math.floor(Math.random() * 12)  + 28
            avgSpeedValue = Math.floor(Math.random() * 30)  + 60
        }
    }

    // =============================================
    // LEFT PANEL — Dashboard content (960px)
    // Scale toàn bộ nội dung 1920px xuống còn 960px
    // =============================================
    Item {
        id: leftPanel
        width: 960
        height: parent.height
        anchors.left: parent.left
        clip: true

        // Scale 1920→960: factor = 0.5, giữ nguyên toàn bộ code gốc bên trong
        Item {
            width: 1920
            height: 1125
            scale: 0.5
            transformOrigin: Item.TopLeft

            Image {
                id: dashboard
                width: parent.width
                height: parent.height
                anchors.centerIn: parent
                source: "qrc:/assets/Dashboard5.svg"

                // --- Top Bar ---
                Image {
                    id: topBar
                    width: 1357
                    source: "qrc:/assets/Vector_ex.svg"
                    anchors { top: parent.top; topMargin: 20; horizontalCenter: parent.horizontalCenter }

                    Image {
                        id: headLight
                        property bool indicator: false
                        width: 42.5; height: 38.25
                        anchors { top: parent.top; topMargin: 25; leftMargin: 230; left: parent.left }
                        source: indicator ? "qrc:/assets/Low beam headlights.svg"
                                          : "qrc:/assets/Low_beam_headlights_white.svg"
                        Behavior on indicator { NumberAnimation { duration: 300 } }
                        MouseArea { anchors.fill: parent; onClicked: headLight.indicator = !headLight.indicator }
                    }

                    Label {
                        id: currentTime
                        text: root.rtcTimeStr               
                        font.pixelSize: 32; font.family: "Inter"; font.bold: Font.DemiBold
                        color: "#FFFFFF"
                        opacity: root.rtcValid ? 1.0 : 0.4     // mờ khi RTC lỗi
                        Behavior on opacity { NumberAnimation { duration: 300 } }
                        anchors { top: parent.top; topMargin: 25; horizontalCenter: parent.horizontalCenter }
                        }


                    Label {
                        id: currentDate
                        text: root.rtcDateStr                
                        font.pixelSize: 32; font.family: "Inter"; font.bold: Font.DemiBold
                        color: "#FFFFFF"
                        opacity: root.rtcValid ? 1.0 : 0.4
                        Behavior on opacity { NumberAnimation { duration: 300 } }
                        anchors { right: parent.right; rightMargin: 230; top: parent.top; topMargin: 25 }
                    }

                }

                // --- Speed Gauge ---
                MapGauge {
                    id: speedLabel
                    width: 450; height: 450
                    property bool accelerating: false
                    value: accelerating ? maximumValue : 0
                    maximumValue: 250
                    anchors { top: parent.top; topMargin: Math.floor(parent.height * 0.25); horizontalCenter: parent.horizontalCenter }
                    Component.onCompleted: forceActiveFocus()
                    Behavior on value { NumberAnimation { duration: 1000 } }
                    Keys.onSpacePressed: accelerating = true
                    Keys.onReleased: {
                        if (event.key === Qt.Key_Space) { accelerating = false; event.accepted = true }
                        else if (event.key === Qt.Key_Enter || event.key === Qt.Key_Return) { accelerating = false; event.accepted = true }
                    }
                    Keys.onEnterPressed:  accelerating = true
                    Keys.onReturnPressed: accelerating = true
                }

                // --- Speed Limit ---
                Rectangle {
                    id: speedLimit
                    width: 130; height: 130; radius: height / 2
                    color: "#D9D9D9"
                    border.color: speedColor(maxSpeedlabel.text)
                    border.width: 10
                    anchors { horizontalCenter: parent.horizontalCenter; bottom: parent.bottom; bottomMargin: 50 }
                    Label {
                        id: maxSpeedlabel
                        text: getRandomInt(150, speedLabel.maximumValue).toFixed(0)
                        font.pixelSize: 45; font.family: "Inter"; font.bold: Font.Bold
                        color: "#01E6DE"
                        anchors.centerIn: parent
                        function getRandomInt(min, max) {
                            return Math.floor(Math.random() * (max - min + 1)) + min
                        }
                    }
                }

                Image {
                    anchors { bottom: car.top; bottomMargin: 30; horizontalCenter: car.horizontalCenter }
                    source: "qrc:/assets/Model 3.png"
                }

                Image {
                    id: car
                    property bool carLightsOn: false   // S11 → car_main_brake.png
                    property bool newCarOn: false       // S12 → newcar.svg
                    // Kích thước theo từng trạng thái (giống Dashboard1)
                    width: newCarOn ? 245 : carLightsOn ? 200 : 112
                    height: newCarOn ? 177 : carLightsOn ? 200 : 107
                    fillMode: Image.PreserveAspectFit
                    anchors { bottom: speedLimit.top; bottomMargin: 30; horizontalCenter: speedLimit.horizontalCenter }
                    source: newCarOn ? "qrc:/assets/newcar.svg"
                            : carLightsOn ? "qrc:/assets/car_main_brake.png"
                            : "qrc:/assets/Car.svg"
                    RotationAnimation on rotation {
                        running: speedLabel.value > 20; loops: Animation.Infinite
                        from: -1; to: 1; duration: 800; easing.type: Easing.InOutQuad
                    }
                }

                // --- Left Road ---
                Image {
                    id: leftRoad
                    width: 127; height: 397
                    anchors { left: speedLimit.left; leftMargin: 100; bottom: parent.bottom; bottomMargin: 26.5 }
                    source: "qrc:/assets/Vector 2.svg"
                }

                // --- Bottom Left info ---
                RowLayout {
                    spacing: 20
                    anchors { left: parent.left; leftMargin: 250; bottom: parent.bottom; bottomMargin: 26.5 + 65 }
                    RowLayout {
                        spacing: 3
                        Label {
                            id: tempFromDHT11
                            text: "25.0°C"
                            font.pixelSize: 32; font.family: "Inter"
                            font.capitalization: Font.AllUppercase; color: "#FFFFFF"
                        }
                        Label {
                            id: humidityFromDHT11
                            text: "50%"
                            font.pixelSize: 28; font.family: "Inter"
                            opacity: 0.7; color: "#01E6DE"
                        }
                    }
                    RowLayout {
                        spacing: 1; Layout.topMargin: 10
                        Repeater {
                            model: 7
                            Rectangle {
                                width: 20; height: 15
                                color: speedLabel.value.toFixed(0) > (31.25 * (index + 1))
                                       ? speedLabel.speedColor : "#01E6DC"
                            }
                        }
                    }
                    Label {
                        text: speedLabel.value.toFixed(0) + " MPH "
                        font.pixelSize: 32; font.family: "Inter"
                        font.capitalization: Font.AllUppercase; color: "#FFFFFF"
                    }
                }

                // --- Right Road ---
                Image {
                    id: rightRoad
                    width: 127; height: 397
                    anchors { right: speedLimit.right; rightMargin: 100; bottom: parent.bottom; bottomMargin: 26.5 }
                    source: "qrc:/assets/Vector 1.svg"
                }

                // --- Gear ---
                RowLayout {
                    spacing: 20
                    anchors { right: parent.right; rightMargin: 350; bottom: parent.bottom; bottomMargin: 26.5 + 65 }
                    Repeater {
                        model: [{ t: "Ready", c: "#32D74B", o: 1.0 },
                                { t: "P",     c: "#FFFFFF", o: 1.0 },
                                { t: "R",     c: "#FFFFFF", o: 0.2 },
                                { t: "N",     c: "#FFFFFF", o: 0.2 },
                                { t: "D",     c: "#FFFFFF", o: 0.2 }]
                        Label {
                            text: modelData.t; opacity: modelData.o; color: modelData.c
                            font.pixelSize: 32; font.family: "Inter"
                            font.capitalization: Font.AllUppercase
                        }
                    }
                }

                // --- Left Icons ---
                Image {
                    id: forthLeftIndicator
                    property bool parkingLightOn: true
                    width: 72; height: 62
                    anchors { left: parent.left; leftMargin: 175; bottom: thirdLeftIndicator.top; bottomMargin: 25 }
                    source: parkingLightOn ? "qrc:/assets/Parking lights.svg" : "qrc:/assets/Parking_lights_white.svg"
                    Behavior on parkingLightOn { NumberAnimation { duration: 300 } }
                    MouseArea { anchors.fill: parent; onClicked: forthLeftIndicator.parkingLightOn = !forthLeftIndicator.parkingLightOn }
                }
                Image {
                    id: thirdLeftIndicator
                    property bool lightOn: true
                    width: 52; height: 70.2
                    anchors { left: parent.left; leftMargin: 145; bottom: secondLeftIndicator.top; bottomMargin: 25 }
                    source: lightOn ? "qrc:/assets/Lights.svg" : "qrc:/assets/Light_White.svg"
                    Behavior on lightOn { NumberAnimation { duration: 300 } }
                    MouseArea { anchors.fill: parent; onClicked: thirdLeftIndicator.lightOn = !thirdLeftIndicator.lightOn }
                }
                Image {
                    id: secondLeftIndicator
                    property bool headLightOn: true
                    width: 51; height: 51
                    anchors { left: parent.left; leftMargin: 125; bottom: firstLeftIndicator.top; bottomMargin: 30 }
                    source: headLightOn ? "qrc:/assets/Low beam headlights.svg" : "qrc:/assets/Low_beam_headlights_white.svg"
                    Behavior on headLightOn { NumberAnimation { duration: 300 } }
                    MouseArea { anchors.fill: parent; onClicked: secondLeftIndicator.headLightOn = !secondLeftIndicator.headLightOn }
                }
                Image {
                    id: firstLeftIndicator
                    property bool rareLightOn: false
                    width: 51; height: 51
                    anchors { left: parent.left; leftMargin: 100; verticalCenter: speedLabel.verticalCenter }
                    source: rareLightOn ? "qrc:/assets/Rare_fog_lights_red.svg" : "qrc:/assets/Rare fog lights.svg"
                    Behavior on rareLightOn { NumberAnimation { duration: 300 } }
                    MouseArea { anchors.fill: parent; onClicked: firstLeftIndicator.rareLightOn = !firstLeftIndicator.rareLightOn }
                }

                // --- Right Icons ---
                Image {
                    id: forthRightIndicator; property bool indicator: true
                    width: 56.83; height: 36.17
                    anchors { right: parent.right; rightMargin: 195; bottom: thirdRightIndicator.top; bottomMargin: 50 }
                    source: indicator ? "qrc:/assets/FourthRightIcon.svg" : "qrc:/assets/FourthRightIcon_red.svg"
                    Behavior on indicator { NumberAnimation { duration: 300 } }
                    MouseArea { anchors.fill: parent; onClicked: forthRightIndicator.indicator = !forthRightIndicator.indicator }
                }
                Image {
                    id: thirdRightIndicator; property bool indicator: true
                    width: 56.83; height: 36.17
                    anchors { right: parent.right; rightMargin: 155; bottom: secondRightIndicator.top; bottomMargin: 50 }
                    source: indicator ? "qrc:/assets/thirdRightIcon.svg" : "qrc:/assets/thirdRightIcon_red.svg"
                    Behavior on indicator { NumberAnimation { duration: 300 } }
                    MouseArea { anchors.fill: parent; onClicked: thirdRightIndicator.indicator = !thirdRightIndicator.indicator }
                }
                Image {
                    id: secondRightIndicator; property bool indicator: true
                    width: 56.83; height: 36.17
                    anchors { right: parent.right; rightMargin: 125; bottom: firstRightIndicator.top; bottomMargin: 50 }
                    source: indicator ? "qrc:/assets/SecondRightIcon.svg" : "qrc:/assets/SecondRightIcon_red.svg"
                    Behavior on indicator { NumberAnimation { duration: 300 } }
                    MouseArea { anchors.fill: parent; onClicked: secondRightIndicator.indicator = !secondRightIndicator.indicator }
                }
                Image {
                    id: firstRightIndicator; property bool sheetBelt: true
                    width: 36; height: 45
                    anchors { right: parent.right; rightMargin: 100; verticalCenter: speedLabel.verticalCenter }
                    source: sheetBelt ? "qrc:/assets/FirstRightIcon.svg" : "qrc:/assets/FirstRightIcon_grey.svg"
                    Behavior on sheetBelt { NumberAnimation { duration: 300 } }
                    MouseArea { anchors.fill: parent; onClicked: firstRightIndicator.sheetBelt = !firstRightIndicator.sheetBelt }
                }

                // --- Battery---
                                Item {
                                    id: battery2D
                                    anchors {
                                        verticalCenter: parent.verticalCenter;
                                        left: parent.left;
                                        leftMargin: parent.width / 6
                                    }

                                    width: 550
                                    height: 200
                                    property real batteryLevel: canHandler.bmsSoc

                                    Behavior on batteryLevel { NumberAnimation { duration: 1000; easing.type: Easing.OutQuad } }

                                    Rectangle {
                                        id: batteryBody
                                        // Tăng kích thước thân pin tương ứng
                                        width: 210
                                        height: 80
                                        anchors.verticalCenter: parent.verticalCenter
                                        color: "transparent"
                                        border.color: "#FFFFFF"
                                        border.width: 4 // Tăng độ dày viền cho cân đối
                                        radius: 10

                                        Rectangle {
                                            anchors {
                                                left: parent.left; top: parent.top; bottom: parent.bottom
                                                margins: 8
                                            }
                                            width: (parent.width - 16) * (battery2D.batteryLevel / 100.0)

                                            // Đổi màu xanh lá cây ở đây (#32D74B)
                                            color: battery2D.batteryLevel <= 20 ? "#FF3B30" : "#32D74B"
                                            radius: 6

                                            Behavior on width { NumberAnimation { duration: 800; easing.type: Easing.OutQuart } }
                                            Behavior on color { ColorAnimation { duration: 500 } }
                                        }

                                        Label {
                                            anchors.centerIn: parent
                                            text: battery2D.batteryLevel.toFixed(0) + "%"
                                            font.pixelSize: 32 // Tăng cỡ chữ
                                            font.family: "Inter"
                                            font.bold: Font.Bold
                                            color: "#FFFFFF"
                                        }
                                    }

                                    Rectangle {
                                        width: 12
                                        height: 32
                                        anchors {
                                            left: batteryBody.right
                                            verticalCenter: batteryBody.verticalCenter
                                            leftMargin: -2
                                        }
                                        color: "#FFFFFF"
                                        radius: 4
                                    }

                                    Label {
                                        anchors {
                                            top: batteryBody.bottom
                                            topMargin: 15
                                            horizontalCenter: batteryBody.horizontalCenter
                                        }
                                        text: "Battery charge"
                                        font.pixelSize: 20 // Tăng cỡ chữ chú thích
                                        font.family: "Inter"
                                        opacity: 0.9
                                        color: "#FFFFFF"
                                    }
                                }



                // --- Right Stats ---
                ColumnLayout {
                    spacing: 40
                    anchors { verticalCenter: parent.verticalCenter; right: parent.right; rightMargin: parent.width / 6 }
                    Repeater {
                        model: [
                            { icon: "qrc:/assets/road.svg",        iw: 72, ih: 50, value: distanceValue + " KM",  label: "Distance" },
                            { icon: "qrc:/assets/fuel.svg",        iw: 72, ih: 78, value: fuelValue + " mpg",     label: "Avg. Fuel Usage" },
                            { icon: "qrc:/assets/speedometer.svg", iw: 72, ih: 72, value: avgSpeedValue + " mph", label: "Avg. Speed" }
                        ]
                        RowLayout {
                            spacing: 30
                            Image { width: modelData.iw; height: modelData.ih; source: modelData.icon }
                            ColumnLayout {
                                Label { text: modelData.value; font.pixelSize: 30; font.family: "Inter"; opacity: 0.8; color: "#FFFFFF" }
                                Label { text: modelData.label; font.pixelSize: 20; font.family: "Inter"; opacity: 0.8; color: "#FFFFFF" }
                            }
                        }
                    }
                }
            } // end Image dashboard
        } // end scale Item

        // =============================================
        // VEHICLE VIEW PANEL — Tesla Model 3
        // =============================================
        Item {
                    id: vehiclePanel
                    width: 960
                    height: parent.height - root.height * 0.5
                    anchors.bottom: parent.bottom

                    // Thiết lập nền đen cho ADAS
                    Rectangle {
                        anchors.fill: parent
                        color: "#08090B"
                        Rectangle { width: parent.width; height: 1; color: "#1A1A2E"; anchors.top: parent.top }
                    }

                    // Tích hợp trực tiếp AdasView
                    Adas {
    			id: adasView
    			anchors.fill: parent
    			proximityDistance: root.ultrasonicDistance
			}
                }
        }

    // =============================================
    // DIVIDER
    // =============================================
    Rectangle {
        id: divider
        width: 1
        height: parent.height
        anchors.left: leftPanel.right
        color: "#33FFFFFF"
    }

    // =============================================
    // RIGHT PANEL — ADAS Placeholder (960px)
    // Tích hợp CameraToolBox khi ADAS
    // =============================================
    property int currentMode: 0 // 0: Đang chạy Video, 1: Đang chạy Camera thật
    Item {
        id: rightPanel
        width: 959
        height: parent.height
        anchors.left: divider.right

        Rectangle { anchors.fill: parent; color: "#080808" }

        // ── Scanline effect ───────────────────────────────────────────────
        Repeater {
            model: 48
            Rectangle {
                x: 0; y: index * 20; width: rightPanel.width; height: 1
                color: "#07FFFFFF"
            }
        }

        // ── Corner brackets ───────────────────────────────────────────────
        Canvas {
            width: 60; height: 60
            anchors { top: parent.top; left: parent.left; margins: 24 }
            onPaint: {
                var c = getContext("2d"); c.strokeStyle = "#01E6DE"; c.lineWidth = 2
                c.beginPath(); c.moveTo(0,40); c.lineTo(0,0); c.lineTo(40,0); c.stroke()
            }
        }
        Canvas {
            width: 60; height: 60
            anchors { top: parent.top; right: parent.right; margins: 24 }
            onPaint: {
                var c = getContext("2d"); c.strokeStyle = "#01E6DE"; c.lineWidth = 2
                c.beginPath(); c.moveTo(60,40); c.lineTo(60,0); c.lineTo(20,0); c.stroke()
            }
        }
        Canvas {
            width: 60; height: 60
            anchors { bottom: parent.bottom; left: parent.left; margins: 24 }
            onPaint: {
                var c = getContext("2d"); c.strokeStyle = "#01E6DE"; c.lineWidth = 2
                c.beginPath(); c.moveTo(0,20); c.lineTo(0,60); c.lineTo(40,60); c.stroke()
            }
        }
        Canvas {
            width: 60; height: 60
            anchors { bottom: parent.bottom; right: parent.right; margins: 24 }
            onPaint: {
                var c = getContext("2d"); c.strokeStyle = "#01E6DE"; c.lineWidth = 2
                c.beginPath(); c.moveTo(60,20); c.lineTo(60,60); c.lineTo(20,60); c.stroke()
            }
        }

        // ── Label top ─────────────────────────────────────────────────────
        Label {
            anchors { top: parent.top; horizontalCenter: parent.horizontalCenter; topMargin: 32 }
            text: "ADAS · OBJECT DETECTION"
            font.pixelSize: 16; font.family: "Inter"; font.letterSpacing: 4
            color: "#01E6DE"; opacity: 0.8
        }
      
	Rectangle {
    		id: btnToggleCamera
    		width: 150
    		height: 36
    		radius: 6
    		anchors { top: parent.top; right: parent.right; topMargin: 24; rightMargin: 24 }
    		color: currentMode === 0 ? "#1A3333" : "#331A1A"  // Đổi màu nền theo chế độ
    		border.color: "#01E6DE"
    		border.width: 1

    	Label {
        	anchors.centerIn: parent
        	text: currentMode === 0 ? "VIDEO STREAM" : "CAMERA REAR"
        	color: "#FFFFFF"
        	font.pixelSize: 11
        	font.family: "Inter"
        	font.bold: true
    	}

    	MouseArea {
        	anchors.fill: parent
        	onClicked: {
            	currentMode = (currentMode === 0) ? 1 : 0

            // 2. Ra lệnh cho C++ tắt tiến trình cũ và chạy tiến trình mới ứng với Mode mới
            	adasHandler.stopAdas()
            	adasHandler.startAdas(currentMode)
        	}
    	}
	}
        

        // ── [WAITING] Hiện khi ADAS chưa sẵn sàng ────────────────────────
        Column {
            anchors.centerIn: parent
            spacing: 32
            visible: !adasHandler.adasReady

            Item {
                width: 120; height: 120
                anchors.horizontalCenter: parent.horizontalCenter

                Rectangle {
                    anchors.centerIn: parent
                    width: 120; height: 120; radius: 60
                    color: "transparent"
                    border.color: "#01E6DE"; border.width: 1
                    opacity: 0
                    SequentialAnimation on opacity {
                        loops: Animation.Infinite
                        NumberAnimation { from: 0.6; to: 0;   duration: 1800 }
                        PauseAnimation  { duration: 400 }
                    }
                    SequentialAnimation on scale {
                        loops: Animation.Infinite
                        NumberAnimation { from: 1.0; to: 1.5; duration: 1800 }
                        PauseAnimation  { duration: 400 }
                    }
                }
                Rectangle {
                    anchors.centerIn: parent
                    width: 80; height: 80; radius: 40
                    color: "transparent"
                    border.color: "#01E6DE"; border.width: 1.5
                }
                Rectangle {
                    anchors.centerIn: parent
                    width: 16; height: 16; radius: 8
                    color: "#01E6DE"
                    SequentialAnimation on opacity {
                        loops: Animation.Infinite
                        NumberAnimation { from: 1; to: 0.3; duration: 900 }
                        NumberAnimation { from: 0.3; to: 1; duration: 900 }
                    }
                }
            }

            Label {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Waiting for ADAS module..."
                font.pixelSize: 22; font.family: "Inter"
                color: "#FFFFFF"; opacity: 0.5
            }

            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 10
                Repeater {
                    model: 3
                    Rectangle {
                        width: 8; height: 8; radius: 4; color: "#01E6DE"
                        SequentialAnimation on opacity {
                            loops: Animation.Infinite
                            PauseAnimation  { duration: index * 300 }
                            NumberAnimation { from: 0.2; to: 1;   duration: 400 }
                            NumberAnimation { from: 1;   to: 0.2; duration: 400 }
                        }
                    }
                }
            }
        }

        // ── [LIVE VIEW] Hiện khi ADAS online ─────────────────────────────
        Item {
            anchors {
                top: parent.top;    topMargin:    72
                bottom: statusBar.top; bottomMargin: 8
                left: parent.left;  leftMargin:   24
                right: parent.right; rightMargin: 24
            }
            visible: adasHandler.adasReady

            // Camera frame — reload mỗi khi framePath thay đổi
            Image {
                id: adasFrame
                anchors.fill: parent
                source: adasHandler.framePath   // C++ emit framePathChanged() mỗi 100ms
                cache: false                     // QUAN TRỌNG: không cache
                smooth: false                    // tắt AA cho nhanh hơn trên RPi
                fillMode: Image.PreserveAspectFit

                Behavior on opacity { NumberAnimation { duration: 300 } }
                opacity: status === Image.Ready ? 1.0 : 0.0
            }
            
            Canvas {
                id: parkingLinesCanvas
                anchors.fill: adasFrame // Tự động khít theo khung hình camera
                
                // Chỉ hiển thị ở chế độ camera thực tế (mode = 1) và khi ADAS online
                visible: currentMode === 1 && adasHandler.adasReady 

                // FIX LỖI Ở ĐÂY: Ép Canvas phải vẽ lại khi trạng thái visible thay đổi thành true
                onVisibleChanged: {
                    if (visible) {
                        requestPaint()
                    }
                }

                // Cập nhật lại hình vẽ mỗi khi kích thước màn hình thay đổi
                onWidthChanged:  requestPaint()
                onHeightChanged: requestPaint()

                onPaint: {
                    var ctx = getContext("2d");
                    ctx.reset(); // Xóa hình vẽ cũ để vẽ lại khung hình mới

                    var w = width;
                    var h = height;

                    // Chặn vẽ nếu kích thước chưa được load xong để tránh lỗi
                    if (w === 0 || h === 0) return;

                    // ---------------------------------------------------------
                    // 1. ĐỊNH NGHĨA CÁC ĐIỂM TỌA ĐỘ THEO TỶ LỆ (Phối cảnh hình thang)
                    //    Khi góc lái = 0 thì vạch vẽ THẲNG đúng như cũ.
                    // ---------------------------------------------------------
                    var bLeftX  = w * 0.15; // Cách mép trái 15% chiều rộng
                    var bRightX = w * 0.85; // Cách mép phải 15% chiều rộng
                    var bY      = h * 0.84; // Cách cạnh dưới 5% chiều cao

                    var tLeftX  = w * 0.38; // Thu hẹp vào tâm trái 38%
                    var tRightX = w * 0.62; // Thu hẹp vào tâm phải 62%
                    var tY      = h * 0.40; // Dừng lại ở giữa màn hình (40% chiều cao)

                    // Góc lái -1..+1 và độ "văng" tối đa của đầu xa khi đánh hết lái
                    var steer    = root.steeringNorm;
                    var maxShift = w * 0.28;

                    // Độ lệch ngang tại một độ cao Y: càng lên cao (càng xa xe) cong càng
                    // nhiều -> dùng p^2 cho giống quỹ đạo xe thật.
                    function curveAt(targetY) {
                        var p = (bY - targetY) / (bY - tY); // 0 ở đáy, 1 ở đỉnh
                        if (p < 0) p = 0;
                        if (p > 1) p = 1;
                        return steer * maxShift * p * p;
                    }

                    // X "thẳng" nội suy theo Y giữa điểm đáy và điểm đỉnh
                    function baseX(startX, endX, targetY) {
                        return startX + (endX - startX) * ((targetY - bY) / (tY - bY));
                    }

                    // X cuối cùng = X thẳng + độ cong theo góc lái
                    function lineX(startX, endX, targetY) {
                        return baseX(startX, endX, targetY) + curveAt(targetY);
                    }

                    // Vẽ một vạch dọc cong bằng nhiều đoạn nhỏ (polyline)
                    function drawCurvedGuide(startX, endX) {
                        ctx.beginPath();
                        var steps = 24;
                        for (var i = 0; i <= steps; i++) {
                            var y = bY + (tY - bY) * (i / steps);
                            var x = lineX(startX, endX, y);
                            if (i === 0) ctx.moveTo(x, y);
                            else         ctx.lineTo(x, y);
                        }
                        ctx.stroke();
                    }

                    // ---------------------------------------------------------
                    // 2. VẼ 2 VẠCH ĐƯỜNG DẪN HƯỚNG CHÍNH (Màu Vàng) - đã uốn cong
                    // ---------------------------------------------------------
                    ctx.lineWidth = 5;
                    ctx.strokeStyle = "#FFD700";
                    drawCurvedGuide(bLeftX, tLeftX);
                    drawCurvedGuide(bRightX, tRightX);

                    // ---------------------------------------------------------
                    // 3. VẼ VẠCH NGANG CẢNH BÁO NGUY HIỂM (Màu Đỏ - Gần xe)
                    // ---------------------------------------------------------
                    var redY = h * 0.72;
                    ctx.lineWidth = 6;
                    ctx.strokeStyle = "#FF3B30";
                    ctx.beginPath();
                    ctx.moveTo(lineX(bLeftX,  tLeftX,  redY), redY);
                    ctx.lineTo(lineX(bRightX, tRightX, redY), redY);
                    ctx.stroke();

                    // ---------------------------------------------------------
                    // 4. VẼ VẠCH NGANG AN TOÀN TRUNG TÂM (Màu Vàng - Tầm trung)
                    // ---------------------------------------------------------
                    var yellowY = h * 0.58;
                    ctx.lineWidth = 5;
                    ctx.strokeStyle = "#FFD700";
                    ctx.beginPath();
                    ctx.moveTo(lineX(bLeftX,  tLeftX,  yellowY), yellowY);
                    ctx.lineTo(lineX(bRightX, tRightX, yellowY), yellowY);
                    ctx.stroke();

                    // ---------------------------------------------------------
                    // 5. VẼ TAI MÓC GIỚI HẠN PHÍA XA (Góc vuông nhỏ ở đỉnh đã cong)
                    // ---------------------------------------------------------
                    var topLX = lineX(bLeftX,  tLeftX,  tY);
                    var topRX = lineX(bRightX, tRightX, tY);
                    ctx.lineWidth = 4;
                    ctx.strokeStyle = "#FFD700";
                    ctx.beginPath();
                    ctx.moveTo(topLX, tY);
                    ctx.lineTo(topLX + (w * 0.04), tY);
                    ctx.moveTo(topRX, tY);
                    ctx.lineTo(topRX - (w * 0.04), tY);
                    ctx.stroke();
                }
            }
           
            // Placeholder khi chờ frame đầu tiên
            Label {
                anchors.centerIn: parent
                visible: adasFrame.status !== Image.Ready
                text: "Initializing camera..."
                color: "#01E6DE"; opacity: 0.5
                font.pixelSize: 16; font.family: "Inter"
            }

            // ── HUD: Stats góc trên trái ───────────────────────────────
            Rectangle {
                anchors { top: parent.top; left: parent.left; topMargin: 8; leftMargin: 8 }
                width:  hudRow.implicitWidth + 24
                height: 30
                radius: 4
                color:  "#BB000000"

                Row {
                    id: hudRow
                    anchors { left: parent.left; leftMargin: 12; verticalCenter: parent.verticalCenter }
                    spacing: 14

                    Label {
                        text: "V " + adasHandler.videoFps.toFixed(0) + " fps"
                        font.pixelSize: 12; font.family: "Inter"
                        color: "#01E6DE"
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    Label {
                        text: "AI " + adasHandler.aiFps.toFixed(1) + " fps"
                        font.pixelSize: 12; font.family: "Inter"
                        color: "#FFFFFF"; opacity: 0.8
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    Label {
                        text: "● " + adasHandler.objectCount
                        font.pixelSize: 12; font.family: "Inter"
                        color: adasHandler.objectCount > 0 ? "#FF6B35" : "#FFFFFF"
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }

            // ── Object tags góc dưới trái ──────────────────────────────
            Column {
                anchors { bottom: parent.bottom; left: parent.left; bottomMargin: 8; leftMargin: 8 }
                spacing: 4

                Repeater {
                    model: adasHandler.detectedObjects
                    Rectangle {
                        width: tagLabel.implicitWidth + 16; height: 24; radius: 3
                        color: "#CC01E6DE"
                        Label {
                            id: tagLabel
                            anchors.centerIn: parent
                            text: modelData
                            font.pixelSize: 11; font.family: "Inter"
                            font.bold: true; color: "#000000"
                        }
                    }
                }
            }
        }

        // ── Status bar (bottom) ────────────────────────────────────────────
        Rectangle {
            id: statusBar
            anchors {
                bottom: parent.bottom; left: parent.left; right: parent.right
                bottomMargin: 24; leftMargin: 24; rightMargin: 24
            }
            height: 36; radius: 4
            color: "#0F1A1A"
            border.color: adasHandler.adasReady ? "#1A3333" : "#331A1A"
            border.width: 1

            Row {
                anchors { left: parent.left; leftMargin: 16; verticalCenter: parent.verticalCenter }
                spacing: 8
                Rectangle {
                    width: 8; height: 8; radius: 4
                    color: adasHandler.adasReady ? "#32D74B" : "#FF6B35"
                    anchors.verticalCenter: parent.verticalCenter
                    SequentialAnimation on opacity {
                        running: adasHandler.adasReady
                        loops: Animation.Infinite
                        NumberAnimation { from: 1.0; to: 0.3; duration: 700 }
                        NumberAnimation { from: 0.3; to: 1.0; duration: 700 }
                    }
                }
                Label {
                    text: adasHandler.adasReady ? "ONLINE" : "OFFLINE"
                    font.pixelSize: 12; font.family: "Inter"; font.letterSpacing: 2
                    color: adasHandler.adasReady ? "#32D74B" : "#FF6B35"; opacity: 0.9
                    anchors.verticalCenter: parent.verticalCenter
                    Behavior on color { ColorAnimation { duration: 500 } }
                }
            }

            Label {
                anchors { right: parent.right; rightMargin: 16; verticalCenter: parent.verticalCenter }
                text: adasHandler.adasReady ? "YOLOv8s · NCNN · PiCam2" : "OpenCV · HoughLinesP"
                font.pixelSize: 11; font.family: "Inter"; font.letterSpacing: 1
                color: "#FFFFFF"; opacity: 0.25
                Behavior on text { }
            }
        }
    }

    // Timer hazard: nháy ĐỒNG BỘ cả 2 đèn LED phần cứng (ch8 trái + ch12 phải) khi crash.
    Timer {
        id: hazardTimer
        interval: 500
        repeat: true
        running: false
        onTriggered: {
            hazardOn = !hazardOn
            canHandler.sendOutputCommand(8,  1, hazardOn ? 100 : 0)
            canHandler.sendOutputCommand(12, 1, hazardOn ? 100 : 0)
        }
    }

    // Sau 20s kể từ lúc crash: chỉ TẮT overlay UI; hazardTimer vẫn chạy -> đèn vẫn nháy.
    Timer {
        id: crashUITimer
        interval: 20000
        repeat: false
        running: false
        onTriggered: isCrashed = false
    }

    // =============================================
    // CAN CONNECTIONS (giữ nguyên)
    // =============================================
    Connections {
        target: canHandler

        onLeftLightChanged:   console.log("Left turn signal:", leftLight)
        onRightLightChanged:  console.log("Right turn signal:", rightLight)
        onHazardLightsChanged: console.log("Hazard lights:", hazardLights)
        onHighBeamChanged:    console.log("High beam:", highBeam)

        onLowBeamChanged:     { headLight.indicator = lowBeam }
        onParkingLightsChanged: { forthLeftIndicator.parkingLightOn = parkingLights }

        onSpeedChanged: {
            var calculatedSpeed = speed * speedLabel.maximumValue / 4000
            speedLabel.value = Math.max(0, Math.min(speedLabel.maximumValue, calculatedSpeed))

            // Pot vô-lăng: 0..4000, giữa (~2000) = thẳng. Chuẩn hoá ra -1..+1
            var s = (speed - 2000) / 2000
            root.steeringNorm = Math.max(-1, Math.min(1, s))
        }
        onBatteryChanged: { console.log("Analog Battery ignored, using BMS SoC"); }
        onTemperatureChanged: { tempFromDHT11.text   = ((temperature / 4095.0) * 50.0).toFixed(1) + "°C" }
        onHumidityChanged:    { humidityFromDHT11.text = ((humidity / 4095.0) * 100.0).toFixed(0) + "%" }
        onCarLightsToggled:   {
            // S11: đổi Car.svg ↔ car_main_brake.png
            car.carLightsOn = state
            if (state) car.newCarOn = false   // loại trừ S12 khi bật S11
            console.log("S11 pressed: Car lights =", state)
        }
        onSpecificButtonPressed: {
            // S12 (buttonId = 11): đổi Car.svg ↔ newcar.svg
            if (buttonId === 11) {
                car.newCarOn = !car.newCarOn
                if (car.newCarOn) car.carLightsOn = false   // loại trừ S11 khi bật S12
                console.log("S12 pressed: newCar =", car.newCarOn)
            }
        }
        onUltrasonicDistanceChanged: {
                    ultrasonicDistance = distanceCm
                    if (distanceCm < 30)
                        console.log("DISTANCE DANGER: ", distanceCm, "cm")
                    else if (distanceCm < 100)
                        console.log("WARNING ", distanceCm, "cm")
                }
        
        onRtcTimeChanged: {
            // year, month, date, hours, minutes, seconds, dow, valid
            function pad(n) { return (n < 10 ? "0" : "") + n }

            root.rtcValid = valid
            if (valid) {
                root.rtcTimeStr = pad(hours) + ":" + pad(minutes) + ":" + pad(seconds)
                root.rtcDateStr = pad(date) + "/" + pad(month) + "/" + year
                root.rtcDowStr  = (dow >= 1 && dow <= 7) ? root.dowNames[dow] : ""
            }
        }

        onCrashDetected: {
            // Chống dội: bỏ qua tín hiệu lặp -> không restart hazardTimer (tránh nháy giật).
            if (isCrashed)
                return

            isCrashed = true
            speedLabel.value = 0

            // Ép nháy đèn hazard (ch8 + ch12) đồng bộ.
            hazardOn = false
            hazardTimer.start()

            // Hẹn giờ tắt overlay UI sau 20s (đèn vẫn nháy tiếp).
            crashUITimer.restart()
        }

    }

    // Màn hình cảnh báo túi khí
    Rectangle {
        id: airbagWarningOverlay
        anchors.fill: parent
        color: "#D90000"
        opacity: 0
        visible: isCrashed
        z: 999

        ColumnLayout {
            anchors.centerIn: parent
            spacing: 20

            Image {
                source: "qrc:/assets/airbag_icon.png"
                Layout.alignment: Qt.AlignHCenter
                width: 150
                height: 150
            }

            Label {
                text: "CRASH DETECTED\nAIRBAG DEPLOYED!"
                font.pixelSize: 80
                font.family: "Inter"
                font.bold: Font.Black
                color: "#FFFFFF"
                horizontalAlignment: Text.AlignHCenter
                Layout.alignment: Qt.AlignHCenter
            }
        }

        SequentialAnimation {
            id: crashAnimation
            running: isCrashed
            loops: Animation.Infinite
            NumberAnimation { target: airbagWarningOverlay; property: "opacity"; from: 0.0; to: 0.9; duration: 150 }
            NumberAnimation { target: airbagWarningOverlay; property: "opacity"; from: 0.9; to: 0.4; duration: 250 }
        }
    }
}
