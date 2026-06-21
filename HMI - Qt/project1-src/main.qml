import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12

ApplicationWindow {
    id: root
    width: Screen.width
    height: Screen.height
    visible: true
    title: qsTr("Car Dashboard")
    color: "#1E1E1E"

    visibility: Window.FullScreen

    readonly property real designWidth: 1920
    readonly property real designHeight: 1125

    readonly property real scaleX: width / designWidth
    readonly property real scaleY: height / designHeight
    readonly property real scale: Math.min(scaleX, scaleY)

    property bool showWelcome: true

    Item {
        id: scaledContainer
        width: root.designWidth
        height: root.designHeight
        anchors.centerIn: parent
        scale: root.scale
        transformOrigin: Item.Center

        // Welcome screen
        WelcomeScreen {
            id: welcomeScreen
            visible: showWelcome
            anchors.fill: parent
            z: 2

            function switchToDashboard() {
                welcomeFadeOut.start()
            }
        }

        // SwipeView for dashboards
        SwipeView {
            id: swipeView
            anchors.fill: parent
            visible: !showWelcome
            z: 1
            currentIndex: 0
            clip: true

            onCurrentIndexChanged: {
                console.log("Switching to Dashboard", currentIndex + 1)

                // ── Load dashboard lazy ──────────────────────────────────
                if (currentIndex === 0 && !dashboard1Loader.active)
                    dashboard1Loader.active = true
                if (currentIndex === 1 && !dashboard2Loader.active)
                    dashboard2Loader.active = true
                if (currentIndex === 2 && !dashboard3Loader.active)
                    dashboard3Loader.active = true

                // ── ADAS: start khi vào Dashboard2, stop khi rời đi ─────
                if (currentIndex === 1) {
                    console.log("[ADAS] Starting ADAS module...")
                    adasHandler.startAdas(0)
                } else {
                    console.log("[ADAS] Stopping ADAS module...")
                    adasHandler.stopAdas()
                }
            }

            // Dashboard 1
            Loader {
                id: dashboard1Loader
                active: true
                asynchronous: true
                source: "Dashboard1.qml"
                onStatusChanged: {
                    if (status === Loader.Error)
                        console.error("Dashboard1 load error:", sourceComponent)
                    else if (status === Loader.Ready)
                        console.log("Dashboard1 loaded")
                }
            }

            // Dashboard 2
            Loader {
                id: dashboard2Loader
                active: false
                asynchronous: true
                source: "Dashboard2.qml"
                onStatusChanged: {
                    if (status === Loader.Error)
                        console.error("Dashboard2 load error:", sourceComponent)
                    else if (status === Loader.Ready)
                        console.log("Dashboard2 loaded")
                    else if (status === Loader.Loading)
                        console.log("Dashboard2 loading...")
                }
            }

            // Dashboard 3
            Loader {
                id: dashboard3Loader
                active: false
                asynchronous: true
                source: "Dashboard3.qml"
                onStatusChanged: {
                    if (status === Loader.Error)
                        console.error("Dashboard3 load error:", sourceComponent)
                    else if (status === Loader.Ready)
                        console.log("Dashboard3 loaded")
                }
            }
        }

        // Page indicator (giữ nguyên)
        PageIndicator {
            id: pageIndicator
            visible: !showWelcome
            count: swipeView.count
            currentIndex: swipeView.currentIndex
            anchors {
                bottom: parent.bottom
                horizontalCenter: parent.horizontalCenter
                bottomMargin: 30
            }
            z: 999
            delegate: Rectangle {
                width: 12; height: 12; radius: 6
                color: index === pageIndicator.currentIndex ? "#01E6DE" : "#40FFFFFF"
                Behavior on color { ColorAnimation { duration: 200 } }
            }
        }
    }

    // Fade out animation (giữ nguyên)
    OpacityAnimator {
        id: welcomeFadeOut
        target: welcomeScreen
        from: 1.0; to: 0.0
        duration: 1000
        onStopped: {
            showWelcome = false
            welcomeScreen.visible = false
        }
    }

    // ── Shortcuts (giữ nguyên) ──────────────────────────────────────────────
    Shortcut {
        sequence: "Ctrl+Q"
        context: Qt.ApplicationShortcut
        onActivated: Qt.quit()
    }
    Shortcut {
        sequence: "Ctrl+S"
        context: Qt.ApplicationShortcut
        onActivated: {
            if (!showWelcome)
                swipeView.currentIndex = (swipeView.currentIndex + 1) % swipeView.count
        }
    }
    Shortcut {
        sequence: "F11"
        context: Qt.ApplicationShortcut
        onActivated: {
            if (root.visibility === Window.FullScreen)
                root.visibility = Window.Maximized
            else
                root.visibility = Window.FullScreen
        }
    }
    Shortcut {
        sequence: "Ctrl+D"
        context: Qt.ApplicationShortcut
        onActivated: {
            console.log("=== DASHBOARD INFO ===")
            console.log("Window size:", root.width, "x", root.height)
            console.log("Current dashboard:", swipeView.currentIndex + 1)
            console.log("ADAS ready:", adasHandler.adasReady)
            console.log("ADAS fps:", adasHandler.videoFps, "/", adasHandler.aiFps)
        }
    }

    Component.onCompleted: {
        console.log("=== CAR DASHBOARD STARTED ===")
        console.log("Screen:", Screen.width, "x", Screen.height)
        console.log("Scale:", root.scale)
    }
}
