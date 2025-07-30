import QtQuick
import Quickshell
import qs.Settings
import qs.Services

Column {
    id: layout
    spacing: 10
    visible: Settings.settings.showSystemInfoInBar

    Column {
        id: cpuUsageLayout
        spacing: 6

        Text {
            id: cpuUsageIcon
            font.family: "Material Symbols Outlined"
            font.pixelSize: Theme.fontSizeBody
            text: "speed"
            verticalAlignment: Text.AlignVCenter
            anchors.horizontalCenter: parent.horizontalCenter
            color: Theme.accentPrimary
        }

        Text {
            id: cpuUsageText
            font.family: Theme.fontFamilyMono
            font.pixelSize: Theme.fontSizeCaption
            color: Theme.textPrimary
            text: Sysinfo.cpuUsageStr
            anchors.horizontalCenter: parent.horizontalCenter
            horizontalAlignment: Text.AlignHCenter
        }
    }

    // CPU Temperature Component
    Column {
        id: cpuTempLayout
        spacing: 3
        Text {
            font.family: "Material Symbols Outlined"
            font.pixelSize: Theme.fontSizeBody
            text: "thermometer"
            verticalAlignment: Text.AlignVCenter
            anchors.horizontalCenter: parent.horizontalCenter
            color: Theme.accentPrimary
        }

        Text {
            font.family: Theme.fontFamilyMono
            font.pixelSize: Theme.fontSizeCaption
            color: Theme.textPrimary
            text: Sysinfo.cpuTempStr
            anchors.horizontalCenter: parent.horizontalCenter
            horizontalAlignment: Text.AlignHCenter
        }
    }

    // Memory Usage Component
    Column {
        id: memoryUsageLayout
        spacing: 6
        Text {
            font.family: "Material Symbols Outlined"
            font.pixelSize: Theme.fontSizeBody
            text: "memory"
            color: Theme.accentPrimary
            horizontalAlignment: Text.AlignHCenter
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Text {
            font.family: Theme.fontFamilyMono
            font.pixelSize: Theme.fontSizeCaption
            color: Theme.textPrimary
            text: Sysinfo.memoryUsageStr
            horizontalAlignment: Text.AlignHCenter
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }
}
