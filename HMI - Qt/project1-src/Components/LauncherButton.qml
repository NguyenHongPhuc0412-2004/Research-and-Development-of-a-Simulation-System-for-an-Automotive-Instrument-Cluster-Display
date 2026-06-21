import QtQuick 2.9
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import Style 1.0
import QtGraphicalEffects 1.0


Button {
    id: control
    

    property real sf: Math.min(ApplicationWindow.window.width / 1920, ApplicationWindow.window.height / 960)
    
    property bool isGlow: false
    property color textColor: Style.white
    
    // Ép cứng kích thước thu nhỏ
    implicitWidth: 80 * sf
    implicitHeight: 90 * sf

    contentItem: ColumnLayout {
        anchors.fill: parent
        anchors.margins: 4 * sf
        spacing: 2 * sf

        Item { Layout.fillHeight: true }

        Image {
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: 32 * sf
            Layout.preferredHeight: 32 * sf
            
            source: control.icon.source
            sourceSize.width: 32 * sf
            sourceSize.height: 32 * sf
            fillMode: Image.PreserveAspectFit
            scale: control.pressed ? 0.9 : 1.0
            Behavior on scale { NumberAnimation { duration: 200; } }
        }

        Text {
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: 76 * sf
            Layout.maximumWidth: 76 * sf

            text: control.text
            font.family: control.font.family
            font.pixelSize: 11 * sf
            color: textColor
            horizontalAlignment: Text.AlignHCenter
            
            // Giữ chữ trên 1 dòng
            fontSizeMode: Text.Fit
            minimumPixelSize: 7 * sf
            wrapMode: Text.NoWrap
        }

        Item { Layout.fillHeight: true }
    }

    background: Rectangle {
        anchors.fill: parent
        radius: width
        color: "transparent"
        border.width: 0
        border.color: "transparent"
        visible: false
        Behavior on color {
            ColorAnimation {
                duration: 200;
                easing.type: Easing.Linear;
            }
        }

        Rectangle {
            id: indicator
            property int mx
            property int my
            x: mx - width / 2
            y: my - height / 2
            height: width
            radius: width / 2
            color: isGlow ? Qt.lighter("#29BEB6") : Qt.lighter("#B8FF01")
        }
    }

    Rectangle {
        id: mask
        radius: width
        anchors.fill: parent
        visible: false
    }

    OpacityMask {
        anchors.fill: background
        source: background
        maskSource: mask
    }

    MouseArea {
        id: mouseArea
        hoverEnabled: true
        acceptedButtons: Qt.NoButton
        cursorShape: Qt.PointingHandCursor
        anchors.fill: parent
    }

    ParallelAnimation {
        id: anim
        NumberAnimation {
            target: indicator
            property: 'width'
            from: 0
            to: control.width * 1.2
            duration: 200
        }
        NumberAnimation {
            target: indicator;
            property: 'opacity'
            from: 0.9
            to: 0
            duration: 200
        }
    }

    onPressed: {
        indicator.mx = mouseArea.mouseX
        indicator.my = mouseArea.mouseY
        anim.restart();
    }
}
