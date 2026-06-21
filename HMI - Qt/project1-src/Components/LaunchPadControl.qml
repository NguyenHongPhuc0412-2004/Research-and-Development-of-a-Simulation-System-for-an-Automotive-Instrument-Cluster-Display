import QtQuick 2.9
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import Style 1.0
import QtGraphicalEffects 1.0

Popup {
    id: launchPad

    // BÍ QUYẾT 2: Tính tỷ lệ màn hình thật
    property real sf: Math.min(ApplicationWindow.window.width / 1920, ApplicationWindow.window.height / 960)

    padding: 16 * sf
    modal: true
    dim: false
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

    // Thu nhỏ tổng thể cái bảng
    width: 700 * sf
    height: 350 * sf

    background: Rectangle {
        radius: 12 * sf
        color: Style.alphaColor(Style.black, 0.85)
    }

    contentItem: ColumnLayout {
        spacing: 10 * sf

        // Hàng 1
        RowLayout {
            Layout.alignment: Qt.AlignHCenter // Tự động căn giữa, xóa bỏ leftMargin
            spacing: 14 * sf
            LauncherButton { icon.source: "qrc:/icons/app_icons/front-defrost.svg"; text: "Front Defrost" }
            LauncherButton { icon.source: "qrc:/icons/app_icons/rear-defrost.svg"; text: "Rear Defrost" }
            LauncherButton { icon.source: "qrc:/icons/app_icons/seat.svg"; text: "Left Seat" }
            LauncherButton { icon.source: "qrc:/icons/app_icons/steering-wheel-warmer.svg"; text: "Heated Steering" }
            LauncherButton { icon.source: "qrc:/icons/app_icons/wiper.svg"; text: "Wipers" }
        }

        // Đường phân cách
        Rectangle {
            Layout.fillWidth: true
            Layout.leftMargin: 24 * sf
            Layout.rightMargin: 24 * sf
            height: 1
            color: Style.black30
        }

        // Hàng 2
        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 14 * sf
            LauncherButton { icon.source: "qrc:/icons/app_icons/dashcam.svg"; text: "Dashcam" }
            LauncherButton { icon.source: "qrc:/icons/app_icons/calendar.svg"; text: "Calendar" }
            LauncherButton { icon.source: "qrc:/icons/app_icons/messages.svg"; text: "Messages" }
            LauncherButton { icon.source: "qrc:/icons/app_icons/zoom.svg"; text: "Zoom" }
            LauncherButton { icon.source: "qrc:/icons/app_icons/video.svg"; text: "Theater" }
            LauncherButton { icon.source: "qrc:/icons/app_icons/toybox.svg"; text: "Toybox" }
            LauncherButton { icon.source: "qrc:/icons/app_icons/spotify.svg"; text: "Spotify" }
        }

        // Hàng 3
        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 14 * sf
            LauncherButton { icon.source: "qrc:/icons/app_icons/caraoke.svg"; text: "Caraoke" }
            LauncherButton { icon.source: "qrc:/icons/app_icons/tunein.svg"; text: "TuneIn" }
            LauncherButton { icon.source: "qrc:/icons/app_icons/radio.svg"; text: "Music" }
        }
    }
}
