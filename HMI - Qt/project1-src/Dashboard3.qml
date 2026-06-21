import QtQuick 2.9
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import Style 1.0
import QtGraphicalEffects 1.0
import QtLocation 5.15
import QtPositioning 5.15
import "Components"
import "qrc:/LayoutManager.js" as Responsive

Rectangle {
    id: root
    anchors.fill: parent
    color: "#171717"

    property var adaptive: new Responsive.AdaptiveLayoutManager(1920, 1200, width, height)

    // ── OSM route simulation state ────────────────────────────────────────
    property real encoderSpeed: 0
    property real speedScale: 0.7
    property real routeProgressMeters: 0
    property real carBearing: 0
    property var startCoord: null
    property var endCoord: null
    property var routePath: []
    property bool routeFinished: false
    property bool routeReady: routePath.length >= 2
    property bool isLoadingRoute: false
    property real totalRouteDistance: 0
    property real estimatedDuration: 0   // seconds at current speed
    property string routeStatusText: ""
    property bool   isCrashed: false
    property bool   hazardOn:  false   // trạng thái nháy hazard nội bộ (Dashboard3 không có icon xi nhan)
    property string rtcTimeStr: "--:--:--"
    property string rtcDateStr: "--/--/----"
    property bool   rtcValid:   false
    property var    dowNames: ["", "Chủ nhật", "Thứ 2", "Thứ 3", "Thứ 4",
                               "Thứ 5", "Thứ 6", "Thứ 7"]
    property string rtcDowStr: ""

    // ── Màu sắc giao diện ─────────────────────────────────────────────────
    readonly property color accentBlue:   "#4A90E2"
    readonly property color accentGreen:  "#27AE60"
    readonly property color accentRed:    "#E74C3C"
    readonly property color accentOrange: "#F39C12"
    readonly property color panelBg:      "#CC0D1117"
    readonly property color panelBorder:  "#33FFFFFF"

    // ── Reset khi chọn lại điểm đầu ──────────────────────────────────────
    function resetRouteWithStart(coord) {
        startCoord    = coord
        endCoord      = null
        routePath     = []
        routeProgressMeters = 0
        routeFinished = false
        carBearing    = 0
        totalRouteDistance  = 0
        estimatedDuration   = 0
        isLoadingRoute      = false
        routeStatusText     = ""
        carItem.coordinate  = coord
        // Auto center map at start point
        navigationMap.center = coord
    }

    // ── Gọi OSRM để lấy route thật ───────────────────────────────────────
    function fetchOSRMRoute(start, end) {
        isLoadingRoute  = true
        routeStatusText = "Đang tìm tuyến đường..."

        // OSRM public API — trả về GeoJSON với danh sách tọa độ thực
        var url = "https://router.project-osrm.org/route/v1/driving/"
                + start.longitude.toFixed(6) + "," + start.latitude.toFixed(6) + ";"
                + end.longitude.toFixed(6)   + "," + end.latitude.toFixed(6)
                + "?overview=full&geometries=geojson&steps=false"

        var xhr = new XMLHttpRequest()
        xhr.open("GET", url, true)
        xhr.timeout = 8000

        xhr.onreadystatechange = function () {
            if (xhr.readyState !== XMLHttpRequest.DONE) return
            isLoadingRoute = false

            if (xhr.status === 200) {
                try {
                    var json   = JSON.parse(xhr.responseText)
                    var route  = json.routes[0]
                    var coords = route.geometry.coordinates   // [ [lon, lat], … ]

                    var pts = []
                    for (var i = 0; i < coords.length; i++) {
                        pts.push(QtPositioning.coordinate(coords[i][1], coords[i][0]))
                    }

                    if (pts.length >= 2) {
                        routePath = pts
                        totalRouteDistance = route.distance          // metres
                        routeProgressMeters = 0
                        routeFinished = false
                        carItem.coordinate = pts[0]
                        carBearing = pts[0].azimuthTo(pts[1])

                        // Zoom bản đồ vừa hiển thị cả route
                        var minLat = pts[0].latitude,  maxLat = pts[0].latitude
                        var minLon = pts[0].longitude, maxLon = pts[0].longitude
                        for (var k = 1; k < pts.length; k++) {
                            if (pts[k].latitude  < minLat) minLat = pts[k].latitude
                            if (pts[k].latitude  > maxLat) maxLat = pts[k].latitude
                            if (pts[k].longitude < minLon) minLon = pts[k].longitude
                            if (pts[k].longitude > maxLon) maxLon = pts[k].longitude
                        }
                        var topLeft     = QtPositioning.coordinate(maxLat, minLon)
                        var bottomRight = QtPositioning.coordinate(minLat, maxLon)
                        var bounds = QtPositioning.rectangle(topLeft, bottomRight)  // ✅
                        navigationMap.visibleRegion = bounds

                        navigationMap.fitViewportToMapItems()
                        routeStatusText = ""
                    } else {
                        fallbackRoute(start, end)
                    }
                } catch (e) {
                    console.log("OSRM parse error:", e)
                    fallbackRoute(start, end)
                }
            } else {
                console.log("OSRM HTTP error:", xhr.status)
                fallbackRoute(start, end)
            }
        }

        xhr.ontimeout = function () {
            isLoadingRoute = false
            routeStatusText = "Hết thời gian, dùng route thẳng"
            fallbackRoute(start, end)
        }

        xhr.send()
    }

    // ── Fallback: route cong nhẹ (Bezier 4 điểm) khi không có mạng ───────
    function fallbackRoute(start, end) {
        var pts   = []
        var steps = 40
        // Tạo đường cong nhẹ bằng cách thêm 2 control points lệch vuông góc
        var midLat = (start.latitude  + end.latitude)  / 2
        var midLon = (start.longitude + end.longitude) / 2
        var dx = end.latitude  - start.latitude
        var dy = end.longitude - start.longitude
        var perp = 0.08   // độ lệch cong
        var cp1Lat = start.latitude  + dx * 0.33 - dy * perp
        var cp1Lon = start.longitude + dy * 0.33 + dx * perp
        var cp2Lat = start.latitude  + dx * 0.66 - dy * perp
        var cp2Lon = start.longitude + dy * 0.66 + dx * perp

        for (var i = 0; i <= steps; i++) {
            var t  = i / steps
            var u  = 1 - t
            // Cubic Bezier
            var lat = u*u*u * start.latitude
                    + 3*u*u*t * cp1Lat
                    + 3*u*t*t * cp2Lat
                    + t*t*t * end.latitude
            var lon = u*u*u * start.longitude
                    + 3*u*u*t * cp1Lon
                    + 3*u*t*t * cp2Lon
                    + t*t*t * end.longitude
            pts.push(QtPositioning.coordinate(lat, lon))
        }

        routePath = pts
        routeProgressMeters = 0
        routeFinished = false
        carItem.coordinate = pts[0]
        carBearing = pts[0].azimuthTo(pts[1])

        // Ước tính tổng khoảng cách
        var total = 0
        for (var j = 0; j < pts.length - 1; j++)
            total += pts[j].distanceTo(pts[j+1])
        totalRouteDistance = total
    }

    function setDestination(coord) {
        endCoord = coord
        fetchOSRMRoute(startCoord, endCoord)
    }

    function routeTotalDistance() {
        if (totalRouteDistance > 0) return totalRouteDistance
        var total = 0
        for (var i = 0; i < routePath.length - 1; i++)
            total += routePath[i].distanceTo(routePath[i + 1])
        return total
    }

    function updateCarPosition(dt) {
        if (!routeReady || routeFinished || encoderSpeed <= 0) return

        routeProgressMeters += encoderSpeed * speedScale * dt

        var total = routeTotalDistance()
        if (routeProgressMeters >= total) {
            routeProgressMeters = total
            carItem.coordinate  = routePath[routePath.length - 1]
            routeFinished = true
            return
        }

        var remain = routeProgressMeters
        for (var i = 0; i < routePath.length - 1; i++) {
            var a = routePath[i]
            var b = routePath[i + 1]
            var segLen = a.distanceTo(b)

            if (remain <= segLen) {
                var ratio = segLen > 0 ? remain / segLen : 0
                var lat = a.latitude  + (b.latitude  - a.latitude)  * ratio
                var lon = a.longitude + (b.longitude - a.longitude) * ratio
                carItem.coordinate = QtPositioning.coordinate(lat, lon)
                carBearing = a.azimuthTo(b)
                return
            }
            remain -= segLen
        }
    }

    // Tính ETA theo tốc độ hiện tại
    function calcETA() {
        if (!routeReady || encoderSpeed <= 0) return "--:--"
        var remain = routeTotalDistance() - routeProgressMeters
        if (remain <= 0) return "Đã đến"
        var secs = remain / (encoderSpeed * speedScale)
        var mins = Math.floor(secs / 60)
        var secsR = Math.floor(secs % 60)
        return (mins < 10 ? "0" : "") + mins + ":" + (secsR < 10 ? "0" : "") + secsR
    }

    onWidthChanged:  { if (adaptive) adaptive.updateWindowWidth(root.width)  }
    onHeightChanged: { if (adaptive) adaptive.updateWindowHeight(root.height) }

    VehicleStore { id: vehicleStore }

    // ── Background ────────────────────────────────────────────────────────
    Loader {
        id: backgroundLoader
        anchors.top:    parent.top
        anchors.bottom: footerLayout.top
        anchors.left:   parent.left
        anchors.right:  parent.right
        sourceComponent: Style.mapAreaVisible ? backgroundRect : backgroundImage
    }

    Header {
        z: 99
        id: headerLayout
        width: parent.width
        anchors.top: parent.top
    }

    Footer {
        id: footerLayout
        width: parent.width
        anchors.bottom: parent.bottom
        onOpenLauncher: launcher.open()
    }

    TopLeftButtonIconColumn {
        z: 99
        visible: !Style.mapAreaVisible && !Style.showRealMap
        anchors.left: parent.left
        anchors.top:  headerLayout.bottom
        anchors.leftMargin: 18
    }

    RowLayout {
        id: mapLayout
        visible: Style.mapAreaVisible && !Style.showRealMap
        spacing: 0
        anchors.fill: parent
        anchors.topMargin:    headerLayout.height
        anchors.bottomMargin: footerLayout.height

        Item {
            Layout.preferredWidth: 620
            Layout.fillHeight: true
            clip: true
            Image {
                anchors.centerIn: parent
                source: Style.isDark
                        ? "qrc:/icons/light/sidebar.png"
                        : "qrc:/icons/dark/sidebar-light.png"
                fillMode: Image.PreserveAspectCrop
            }
        }

        VehicleDashboard {
            Layout.fillWidth:  true
            Layout.fillHeight: true
            store: vehicleStore
        }
    }

    // ═══════════════════════════════════════════════════════════════════════
    // ── Map view ──────────────────────────────────────────────────────────
    // ═══════════════════════════════════════════════════════════════════════
    Item {
        id: realMapArea
        visible: Style.showRealMap
        anchors.fill: parent
        anchors.topMargin:    headerLayout.height
        anchors.bottomMargin: footerLayout.height

        Plugin { id: osmPlugin; name: "osm" }

        Map {
            id: navigationMap
            anchors.fill: parent
            plugin: osmPlugin
            center: QtPositioning.coordinate(10.7769, 106.7009)
            zoomLevel: 14
            copyrightsVisible: false

            // ── Route shadow (hiệu ứng nổi) ──────────────────────────
            MapPolyline {
                id: routeShadow
                visible: root.routeReady
                line.width: 14
                line.color: "#40000000"
                path: root.routePath
            }

            // ── Route outline trắng ───────────────────────────────────
            MapPolyline {
                id: routeOutline
                visible: root.routeReady
                line.width: 10
                line.color: "#FFFFFFFF"
                path: root.routePath
            }

            // ── Route fill (màu chính) ────────────────────────────────
            MapPolyline {
                id: routeLine
                visible: root.routeReady
                line.width: 6
                line.color: root.accentBlue
                path: root.routePath
            }

            // ── Route đã đi qua (màu khác để phân biệt) ──────────────
            MapPolyline {
                id: routeTraversed
                visible: root.routeReady && root.routeProgressMeters > 0
                line.width: 6
                line.color: "#6A9AE2"
                path: {
                    if (!root.routeReady || root.routePath.length < 2) return []
                    // Lấy các điểm đã đi qua
                    var pts = []
                    var remain = root.routeProgressMeters
                    pts.push(root.routePath[0])
                    for (var i = 0; i < root.routePath.length - 1; i++) {
                        var a = root.routePath[i]
                        var b = root.routePath[i + 1]
                        var seg = a.distanceTo(b)
                        if (remain <= seg) {
                            var r = seg > 0 ? remain / seg : 0
                            pts.push(QtPositioning.coordinate(
                                a.latitude  + (b.latitude  - a.latitude)  * r,
                                a.longitude + (b.longitude - a.longitude) * r
                            ))
                            break
                        }
                        pts.push(b)
                        remain -= seg
                    }
                    return pts
                }
            }

            // ── Marker điểm bắt đầu (kiểu Google Maps) ───────────────
            MapQuickItem {
                id: startMarker
                visible: root.startCoord !== null
                coordinate: root.startCoord || navigationMap.center
                anchorPoint.x: 20
                anchorPoint.y: 48

                sourceItem: Item {
                    width: 40; height: 56

                    // Pin body
                    Rectangle {
                        id: startPinBody
                        width: 36; height: 36; radius: 18
                        anchors.horizontalCenter: parent.horizontalCenter
                        y: 0
                        color: root.accentGreen
                        border.color: "white"
                        border.width: 3

                        // Shadow
                        layer.enabled: true
                        layer.effect: DropShadow {
                            transparentBorder: true
                            horizontalOffset: 0; verticalOffset: 3
                            radius: 8; samples: 17
                            color: "#80000000"
                        }

                        // Inner icon
                        Text {
                            anchors.centerIn: parent
                            text: "A"
                            color: "white"
                            font.pixelSize: 14
                            font.bold: true
                            font.family: "Inter"
                        }
                    }

                    // Pin tail
                    Rectangle {
                        width: 4; height: 16; radius: 2
                        anchors.horizontalCenter: parent.horizontalCenter
                        y: 34
                        color: root.accentGreen
                    }

                    // Pin tip dot
                    Rectangle {
                        width: 6; height: 6; radius: 3
                        anchors.horizontalCenter: parent.horizontalCenter
                        y: 48
                        color: root.accentGreen
                    }
                }
            }

            // ── Marker điểm đến ───────────────────────────────────────
            MapQuickItem {
                id: endMarker
                visible: root.endCoord !== null
                coordinate: root.endCoord || navigationMap.center
                anchorPoint.x: 20
                anchorPoint.y: 48

                sourceItem: Item {
                    width: 40; height: 56

                    Rectangle {
                        id: endPinBody
                        width: 36; height: 36; radius: 18
                        anchors.horizontalCenter: parent.horizontalCenter
                        y: 0
                        color: root.accentRed
                        border.color: "white"
                        border.width: 3

                        layer.enabled: true
                        layer.effect: DropShadow {
                            transparentBorder: true
                            horizontalOffset: 0; verticalOffset: 3
                            radius: 8; samples: 17
                            color: "#80000000"
                        }

                        Text {
                            anchors.centerIn: parent
                            text: "B"
                            color: "white"
                            font.pixelSize: 14
                            font.bold: true
                            font.family: "Inter"
                        }
                    }

                    Rectangle {
                        width: 4; height: 16; radius: 2
                        anchors.horizontalCenter: parent.horizontalCenter
                        y: 34
                        color: root.accentRed
                    }

                    // Pulse animation khi chọn destination
                    Rectangle {
                        id: endPulse
                        width: 36; height: 36; radius: 18
                        anchors.centerIn: endPinBody
                        color: "transparent"
                        border.color: root.accentRed
                        border.width: 2
                        opacity: 0

                        SequentialAnimation on opacity {
                            running: root.endCoord !== null && !root.routeReady
                            loops: Animation.Infinite
                            NumberAnimation { to: 0.8; duration: 600 }
                            NumberAnimation { to: 0;   duration: 600 }
                        }

                        NumberAnimation on scale {
                            running: root.endCoord !== null && !root.routeReady
                            from: 1; to: 1.8
                            duration: 1200
                            loops: Animation.Infinite
                        }
                    }

                    Rectangle {
                        width: 6; height: 6; radius: 3
                        anchors.horizontalCenter: parent.horizontalCenter
                        y: 48
                        color: root.accentRed
                    }
                }
            }

            // ── Icon xe ───────────────────────────────────────────────
            MapQuickItem {
                id: carItem
                visible: root.startCoord !== null
                coordinate: root.startCoord || navigationMap.center
                anchorPoint.x: carContainer.width  / 2
                anchorPoint.y: carContainer.height / 2
                z: 10

                sourceItem: Item {
                    id: carContainer
                    width: 70; height: 70

                    // Vòng glow phía sau
                    Rectangle {
                        anchors.centerIn: parent
                        width: 58; height: 58; radius: 29
                        color: "#30" + root.accentBlue.toString().replace("#", "")
                        border.color: "#60" + root.accentBlue.toString().replace("#", "")
                        border.width: 1

                        SequentialAnimation on opacity {
                            running: root.encoderSpeed > 0 && root.routeReady
                            loops: Animation.Infinite
                            NumberAnimation { to: 0.4; duration: 800 }
                            NumberAnimation { to: 1.0; duration: 800 }
                        }
                    }

                    // Shadow dưới xe
                    Rectangle {
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 4
                        width: 40; height: 10; radius: 5
                        color: "#50000000"
                    }

                    // Xe icon
                    Image {
                        id: carIcon
                        anchors.centerIn: parent
                        width: 80; height: 100
                        source: "qrc:/assets/xe1 1.png"
                        fillMode: Image.PreserveAspectFit
                        rotation: root.carBearing
                        transformOrigin: Item.Center
                        smooth: true

                        Behavior on rotation {
                            RotationAnimation {
                                direction: RotationAnimation.Shortest
                                duration: 300
                                easing.type: Easing.OutCubic
                            }
                        }
                    }
                }
            }

            // ── Click handler ─────────────────────────────────────────
            MouseArea {
                id: routeSelectionArea
                anchors.fill: parent
                z: 2
                acceptedButtons: Qt.LeftButton

                onClicked: {
                    var coord = navigationMap.toCoordinate(Qt.point(mouse.x, mouse.y))
                    if (root.startCoord === null || root.endCoord !== null) {
                        root.resetRouteWithStart(coord)
                    } else {
                        root.setDestination(coord)
                    }
                }
            }

            // Pinch zoom
            PinchArea {
                anchors.fill: parent
                z: 1
                onPinchUpdated: {
                    navigationMap.zoomLevel += pinch.scale > 1 ? 0.1 : -0.1
                }
            }

            // ── Timer di chuyển xe ────────────────────────────────────
            Timer {
                id: carMoveTimer
                interval: 50
                running: Style.showRealMap
                repeat: true
                property double lastTime: Date.now()

                onTriggered: {
                    var now = Date.now()
                    var dt  = (now - lastTime) / 1000.0
                    lastTime = now
                    root.updateCarPosition(dt)
                }
            }

            // ── Timer cập nhật ETA ─────────────────────────────────
            Timer {
                interval: 1000
                running: Style.showRealMap && root.routeReady
                repeat: true
                onTriggered: etaText.text = root.calcETA()
            }

        } // end Map

        // ═════════════════════════════════════════════════════════════
        // ── Panel trên (hướng dẫn + thông tin route) ─────────────
        // ═════════════════════════════════════════════════════════════
        Item {
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.topMargin: 16
            anchors.leftMargin: 16
            anchors.rightMargin: 16
            height: 56
            z: 20

            // Nút quay lại (trái)
            Rectangle {
                id: backButton
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                width: 44; height: 44; radius: 22
                color: root.panelBg
                border.color: root.panelBorder
                border.width: 1

                layer.enabled: true
                layer.effect: DropShadow {
                    transparentBorder: true
                    horizontalOffset: 0; verticalOffset: 2
                    radius: 10; samples: 17
                    color: "#60000000"
                }

                Text {
                    anchors.centerIn: parent
                    text: "←"
                    color: "white"
                    font.pixelSize: 18
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: Style.showRealMap = false
                }
            }

            // Banner hướng dẫn (giữa)
            Rectangle {
                anchors.left: backButton.right
                anchors.right: zoomControls.left
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: 10
                anchors.rightMargin: 10
                height: 44; radius: 22
                color: root.panelBg
                border.color: root.panelBorder
                border.width: 1

                layer.enabled: true
                layer.effect: DropShadow {
                    transparentBorder: true
                    horizontalOffset: 0; verticalOffset: 2
                    radius: 10; samples: 17
                    color: "#60000000"
                }

                Row {
                    anchors.centerIn: parent
                    spacing: 8

                    // Loading spinner
                    Rectangle {
                        visible: root.isLoadingRoute
                        width: 16; height: 16; radius: 8
                        color: "transparent"
                        border.color: root.accentBlue
                        border.width: 2
                        anchors.verticalCenter: parent.verticalCenter

                        RotationAnimation on rotation {
                            running: root.isLoadingRoute
                            from: 0; to: 360
                            duration: 800
                            loops: Animation.Infinite
                        }
                    }

                    // Status dot
                    Rectangle {
                        visible: !root.isLoadingRoute
                        width: 8; height: 8; radius: 4
                        anchors.verticalCenter: parent.verticalCenter
                        color: root.startCoord === null ? "#888" :
                               root.endCoord   === null ? root.accentOrange :
                               root.routeFinished       ? root.accentRed :
                               root.encoderSpeed > 0    ? root.accentGreen : root.accentBlue
                    }

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        color: "white"
                        font.pixelSize: 13
                        font.family: "Inter"
                        text: root.routeStatusText !== ""
                              ? root.routeStatusText
                              : root.startCoord === null
                                ? "Nhấn bản đồ để chọn điểm xuất phát"
                                : root.endCoord === null
                                  ? "Nhấn để chọn điểm đến"
                                  : root.isLoadingRoute
                                    ? "Đang tải tuyến đường thực..."
                                    : root.routeFinished
                                      ? "✓ Đã đến điểm đến  —  Nhấn để chọn route mới"
                                      : root.encoderSpeed > 0
                                        ? ("Đang di chuyển  ·  " + root.encoderSpeed.toFixed(0) + " enc/s")
                                        : "Xe đang đứng  ·  Chờ tín hiệu encoder"
                    }
                }
            }

            // Nút zoom (phải)
            Column {
                id: zoomControls
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                spacing: 2

                Rectangle {
                    width: 44; height: 22; radius: 4
                    color: root.panelBg
                    border.color: root.panelBorder
                    border.width: 1
                    Text { anchors.centerIn: parent; text: "+"; color: "white"; font.pixelSize: 16; font.bold: true }
                    MouseArea { anchors.fill: parent; onClicked: navigationMap.zoomLevel = Math.min(20, navigationMap.zoomLevel + 1) }
                }
                Rectangle {
                    width: 44; height: 22; radius: 4
                    color: root.panelBg
                    border.color: root.panelBorder
                    border.width: 1
                    Text { anchors.centerIn: parent; text: "−"; color: "white"; font.pixelSize: 16; font.bold: true }
                    MouseArea { anchors.fill: parent; onClicked: navigationMap.zoomLevel = Math.max(5, navigationMap.zoomLevel - 1) }
                }
            }
        }

        // ═════════════════════════════════════════════════════════════
        // ── Panel thông tin dưới (kiểu Google Maps bottom sheet) ─
        // ═════════════════════════════════════════════════════════════
        Rectangle {
            id: bottomInfoPanel
            visible: root.routeReady
            anchors.bottom: parent.bottom
            anchors.left:   parent.left
            anchors.right:  parent.right
            height: 90
            color: root.panelBg
            border.color: root.panelBorder
            border.width: 1

            // Top highlight line
            Rectangle {
                anchors.top:   parent.top
                anchors.left:  parent.left
                anchors.right: parent.right
                height: 1
                color: "#22FFFFFF"
            }

            layer.enabled: true
            layer.effect: DropShadow {
                transparentBorder: true
                horizontalOffset: 0; verticalOffset: -4
                radius: 16; samples: 33
                color: "#80000000"
            }

            Row {
                anchors.centerIn: parent
                spacing: 0

                // Khoảng cách còn lại
                Column {
                    width: 150
                    spacing: 4
                    anchors.verticalCenter: parent.verticalCenter

                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: root.routeReady
                              ? (((root.routeTotalDistance() - root.routeProgressMeters) / 1000).toFixed(2) + " km")
                              : "-- km"
                        color: "white"
                        font.pixelSize: 22
                        font.bold: true
                        font.family: "Inter"
                    }
                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: "còn lại"
                        color: "#88AAAAAA"
                        font.pixelSize: 11
                        font.family: "Inter"
                    }
                }

                // Divider
                Rectangle { width: 1; height: 50; color: "#33FFFFFF"; anchors.verticalCenter: parent.verticalCenter }

                // ETA
                Column {
                    width: 120
                    spacing: 4
                    anchors.verticalCenter: parent.verticalCenter

                    Text {
                        id: etaText
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: root.calcETA()
                        color: root.accentBlue
                        font.pixelSize: 22
                        font.bold: true
                        font.family: "Inter"
                    }
                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: "thời gian"
                        color: "#88AAAAAA"
                        font.pixelSize: 11
                        font.family: "Inter"
                    }
                }

                Rectangle { width: 1; height: 50; color: "#33FFFFFF"; anchors.verticalCenter: parent.verticalCenter }

                // Tốc độ encoder
                Column {
                    width: 120
                    spacing: 4
                    anchors.verticalCenter: parent.verticalCenter

                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: root.encoderSpeed.toFixed(0)
                        color: root.encoderSpeed > 0 ? root.accentGreen : "#888"
                        font.pixelSize: 22
                        font.bold: true
                        font.family: "Inter"
                    }
                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: "encoder CAN"
                        color: "#88AAAAAA"
                        font.pixelSize: 11
                        font.family: "Inter"
                    }
                }

                Rectangle { width: 1; height: 50; color: "#33FFFFFF"; anchors.verticalCenter: parent.verticalCenter }

                // Tiến trình %
                Column {
                    width: 120
                    spacing: 4
                    anchors.verticalCenter: parent.verticalCenter

                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: root.routeReady
                              ? (Math.min(100, (root.routeProgressMeters / root.routeTotalDistance() * 100)).toFixed(1) + "%")
                              : "0%"
                        color: root.accentOrange
                        font.pixelSize: 22
                        font.bold: true
                        font.family: "Inter"
                    }
                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: "hoàn thành"
                        color: "#88AAAAAA"
                        font.pixelSize: 11
                        font.family: "Inter"
                    }
                }

                Rectangle { width: 1; height: 50; color: "#33FFFFFF"; anchors.verticalCenter: parent.verticalCenter }

                // Tổng khoảng cách
                Column {
                    width: 140
                    spacing: 4
                    anchors.verticalCenter: parent.verticalCenter

                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: (root.routeTotalDistance() / 1000).toFixed(2) + " km"
                        color: "#AAAAAA"
                        font.pixelSize: 22
                        font.bold: true
                        font.family: "Inter"
                    }
                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: "tổng tuyến đường"
                        color: "#88AAAAAA"
                        font.pixelSize: 11
                        font.family: "Inter"
                    }
                }
            }

            // Progress bar
            Rectangle {
                id: progressBarBg
                anchors.bottom: parent.bottom
                anchors.left:   parent.left
                anchors.right:  parent.right
                height: 3
                color: "#22FFFFFF"
                radius: 2

                // 1. Tách riêng logic tính toán tỉ lệ (từ 0 đến 1)
                property real targetProgress: {
                    if (!root.routeReady) return 0;
                    var dist = root.routeTotalDistance();
                    if (dist <= 0) return 0; // Chặn chia cho 0
                    return Math.max(0, Math.min(1, root.routeProgressMeters / dist));
                }

                // 2. Tạo property riêng để gánh hiệu ứng animation
                property real currentProgress: targetProgress

                Behavior on currentProgress {
                    NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
                }

                Rectangle {
                    y: 0
                    x: 0
                    height: parent.height
                    radius: 2
                    color: root.accentBlue

                    // 3. Width chỉ đơn giản là phép nhân, không gắn Behavior ở đây nữa
                    width: parent.width * progressBarBg.currentProgress
                }
            }
        }

        // ═════════════════════════════════════════════════════════════
        // ── Nút Re-center (bottom right) ─────────────────────────
        // ═════════════════════════════════════════════════════════════
        Rectangle {
            anchors.right:  parent.right
            anchors.bottom: bottomInfoPanel.visible ? bottomInfoPanel.top : parent.bottom
            anchors.margins: 16
            width: 48; height: 48; radius: 24
            color: root.panelBg
            border.color: root.panelBorder
            border.width: 1
            z: 20

            layer.enabled: true
            layer.effect: DropShadow {
                transparentBorder: true
                horizontalOffset: 0; verticalOffset: 2
                radius: 10; samples: 17
                color: "#60000000"
            }

            Text {
                anchors.centerIn: parent
                text: "⊕"
                color: root.accentBlue
                font.pixelSize: 22
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    if (carItem.coordinate)
                        navigationMap.center = carItem.coordinate
                }
            }
        }

    } // end realMapArea

    // Timer hazard: nháy ĐỒNG BỘ cả 2 đèn LED phần cứng (ch8 trái + ch12 phải) khi crash.
    Timer {
        id: hazardTimer
        interval: 500
        repeat: true
        running: false
        onTriggered: {
            root.hazardOn = !root.hazardOn
            if (typeof canHandler !== "undefined" && canHandler) {
                canHandler.sendOutputCommand(8,  1, root.hazardOn ? 100 : 0)
                canHandler.sendOutputCommand(12, 1, root.hazardOn ? 100 : 0)
            }
        }
    }

    // Sau 20s kể từ lúc crash: chỉ TẮT overlay UI; hazardTimer vẫn chạy -> đèn vẫn nháy.
    Timer {
        id: crashUITimer
        interval: 20000
        repeat: false
        running: false
        onTriggered: root.isCrashed = false
    }

    // ── Nhận tốc độ encoder từ CAN ───────────────────────────────────────
    Connections {
        target: typeof canHandler !== "undefined" ? canHandler : null

        function onEncoderSpeedChanged(encoderSpeed) {
            root.encoderSpeed = Math.max(0, Math.min(250, encoderSpeed))
        }
        function onSpeedChanged(speed) {
            var decoded = (speed * 250.0) / 4095.0
            root.encoderSpeed = Math.max(0, Math.min(250, decoded))
        }
        function onRtcTimeChanged(year, month, date, hours, minutes, seconds, dow, valid) {
            function pad(n) { return (n < 10 ? "0" : "") + n }
            root.rtcValid = valid
            if (valid) {
                root.rtcTimeStr = pad(hours) + ":" + pad(minutes) + ":" + pad(seconds)
                root.rtcDateStr = pad(date) + "/" + pad(month) + "/" + year
                root.rtcDowStr  = (dow >= 1 && dow <= 7) ? root.dowNames[dow] : ""
            }
        }
        function onCrashDetected() {
            // Chống dội: bỏ qua tín hiệu lặp -> không restart hazardTimer (tránh nháy giật).
            if (root.isCrashed)
                return

            root.isCrashed = true

            // Ép nháy đèn hazard (ch8 + ch12) đồng bộ.
            root.hazardOn = false
            hazardTimer.start()

            // Hẹn giờ tắt overlay UI sau 20s (đèn vẫn nháy tiếp).
            crashUITimer.restart()
        }
    }

    // ── Launcher popup ────────────────────────────────────────────────────
    LaunchPadControl {
        id: launcher
        x: (ApplicationWindow.window.width - width) / 2
        y: ApplicationWindow.window.height - height - (120 * sf)
    }

    // ── Background components ─────────────────────────────────────────────
    Component {
        id: backgroundRect
        Rectangle { color: "#171717"; anchors.fill: parent }
    }

    Component {
        id: backgroundImage
        Image {
            anchors.fill: parent
            source: Style.getImageBasedOnTheme()
            fillMode: Image.PreserveAspectFit

            Icon {
                icon.source: Style.isDark
                    ? "qrc:/icons/car_action_icons/dark/lock.svg"
                    : "qrc:/icons/car_action_icons/lock.svg"
                anchors.horizontalCenter:       parent.horizontalCenter
                anchors.verticalCenter:         parent.verticalCenter
                anchors.verticalCenterOffset:   -350
                anchors.horizontalCenterOffset:  37
            }

            Icon {
                icon.source: Style.isDark
                    ? "qrc:/icons/car_action_icons/dark/Power.svg"
                    : "qrc:/icons/car_action_icons/Power.svg"
                anchors.horizontalCenter:       parent.horizontalCenter
                anchors.verticalCenter:         parent.verticalCenter
                anchors.verticalCenterOffset:   -77
                anchors.horizontalCenterOffset:  550
            }

            ColumnLayout {
                anchors.horizontalCenter:       parent.horizontalCenter
                anchors.verticalCenter:         parent.verticalCenter
                anchors.verticalCenterOffset:   -230
                anchors.horizontalCenterOffset:  440
                spacing: 5
                Text { text: "Trunk"; font.family: "Inter"; font.pixelSize: 14; font.bold: Font.DemiBold; color: Style.black20 }
                Text { text: "Open";  font.family: "Inter"; font.pixelSize: 16; font.bold: Font.Bold; color: Style.isDark ? Style.white : "#171717" }
            }

            ColumnLayout {
                anchors.horizontalCenter:       parent.horizontalCenter
                anchors.verticalCenter:         parent.verticalCenter
                anchors.verticalCenterOffset:   -180
                anchors.horizontalCenterOffset: -350
                spacing: 5
                Text { text: "Frunk"; font.family: "Inter"; font.pixelSize: 14; font.bold: Font.DemiBold; color: Style.black20 }
                Text { text: "Open";  font.family: "Inter"; font.pixelSize: 16; font.bold: Font.Bold; color: Style.isDark ? Style.white : "#171717" }
            }
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
