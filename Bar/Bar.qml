import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Qt5Compat.GraphicalEffects
import qs.Bar.Modules
import qs.Settings
import qs.Services
import qs.Components
import qs.Widgets
import qs.Widgets.Sidebar
import qs.Widgets.Sidebar.Panel
import qs.Helpers
import QtQuick.Controls
import qs.Widgets.Notification

Scope {
    id: rootScope
    property var shell

    Item {
        id: barRootItem
        anchors.fill: parent

        Variants {
            model: Quickshell.screens

            Item {
                property var modelData

                PanelWindow {
                    id: panel
                    screen: modelData
                    color: "transparent"
                    implicitWidth: barBackground.width
                    // had to set this otherwise it would take up more space
                    exclusiveZone: barBackground.width

                    anchors.top: true
                    anchors.bottom: true
                    anchors.left: true

                    visible: true

                    Rectangle {
                        id: barBackground
                        width: 36
                        height: parent.height
                        color: Theme.backgroundPrimary
                        anchors.top: parent.top
                        anchors.left: parent.left
                    }

                    Column {
                        id: leftWidgetsRow
                        anchors.horizontalCenter: barBackground.horizontalCenter
                        anchors.top: barBackground.top
                        anchors.topMargin: 18
                        spacing: 12

                        PanelPopup {
                            id: sidebarPopup
                        }

                        Button {
                            barBackground: barBackground
                            anchors.horizontalCenter: parent.horizontalCenter
                            screen: modelData
                            sidebarPopup: sidebarPopup
                        }

                        SystemInfo {
                            anchors.horizontalCenter: parent.horizontalCenter
                        }

                        Media {
                            anchors.horizontalCenter: parent.horizontalCenter
                        }

                        Taskbar {
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    // Disable Active Window
                    // ActiveWindow {
                    //     screen: modelData
                    // }

                    Workspace {
                        id: workspace
                        screen: modelData
                        anchors.horizontalCenter: barBackground.horizontalCenter
                        anchors.verticalCenter: barBackground.verticalCenter
                    }

                    Column {
                        id: rightWidgetsRow
                        anchors.horizontalCenter: barBackground.horizontalCenter
                        anchors.bottom: barBackground.bottom
                        anchors.bottomMargin: 18
                        spacing: 12

                        NotificationIcon {
                            anchors.horizontalCenter: parent.horizontalCenter
                        }

                        Battery {
                            id: widgetsBattery
                            anchors.horizontalCenter: parent.horizontalCenter
                        }

                        Brightness {
                            id: widgetsBrightness
                            anchors.horizontalCenter: parent.horizontalCenter
                        }

                        Volume {
                            id: widgetsVolume
                            shell: rootScope.shell
                            anchors.horizontalCenter: parent.horizontalCenter
                        }

                        SystemTray {
                            id: systemTrayModule
                            shell: rootScope.shell
                            anchors.horizontalCenter: parent.horizontalCenter
                            bar: panel
                            trayMenu: externalTrayMenu
                        }

                        CustomTrayMenu {
                            id: externalTrayMenu
                        }

                        ClockWidget {
                            screen: modelData
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    Background {}
                    Overview {}
                }

                PanelWindow {
                    id: topLeftPanel
                    anchors.top: true
                    anchors.left: true

                    color: "transparent"
                    screen: modelData
                    margins.left: 36
                    WlrLayershell.exclusionMode: ExclusionMode.Ignore
                    visible: true
                    // WlrLayershell.layer: WlrLayer.Background
                    // aboveWindows: false
                    // WlrLayershell.namespace: "swww-daemon"
                    implicitHeight: 24

                    Corners {
                        id: topLeftCorner
                        position: "bottomleft"
                        size: 1.3
                        fillColor: (Theme.backgroundPrimary !== undefined && Theme.backgroundPrimary !== null) ? Theme.backgroundPrimary : "#222"
                        offsetX: -39
                        offsetY: 0
                        anchors.top: parent.top
                        visible: Settings.settings.showCorners
                    }
                }

                PanelWindow {
                    id: topRightPanel
                    anchors.top: true
                    anchors.right: true
                    color: "transparent"
                    screen: modelData

                    WlrLayershell.exclusionMode: ExclusionMode.Ignore
                    visible: true
                    // WlrLayershell.layer: WlrLayer.Background
                    // aboveWindows: false
                    // WlrLayershell.namespace: "swww-daemon"

                    implicitHeight: 24

                    Corners {
                        id: topRightCorner
                        position: "bottomright"
                        size: 1.3
                        fillColor: (Theme.backgroundPrimary !== undefined && Theme.backgroundPrimary !== null) ? Theme.backgroundPrimary : "#222"
                        offsetX: 39
                        offsetY: 0
                        anchors.top: parent.top
                        visible: Settings.settings.showCorners
                    }
                }

                PanelWindow {
                    id: bottomLeftPanel
                    anchors.bottom: true
                    anchors.left: true
                    color: "transparent"
                    screen: modelData
                    margins.left: 36
                    WlrLayershell.exclusionMode: ExclusionMode.Ignore
                    visible: true
                    // WlrLayershell.layer: WlrLayer.Background
                    // aboveWindows: false
                    // WlrLayershell.namespace: "swww-daemon"

                    implicitHeight: 24

                    Corners {
                        id: bottomLeftCorner
                        position: "topleft"
                        size: 1.3
                        fillColor: Theme.backgroundPrimary
                        offsetX: -39
                        offsetY: 0
                        anchors.top: parent.top
                        visible: Settings.settings.showCorners
                    }
                }

                PanelWindow {
                    id: bottomRightPanel
                    anchors.bottom: true
                    anchors.right: true
                    color: "transparent"
                    screen: modelData
                    WlrLayershell.exclusionMode: ExclusionMode.Ignore
                    visible: true
                    // WlrLayershell.layer: WlrLayer.Background
                    // aboveWindows: false
                    // WlrLayershell.namespace: "swww-daemon"

                    implicitHeight: 24

                    Corners {
                        id: bottomRightCorner
                        position: "topright"
                        size: 1.3
                        fillColor: Theme.backgroundPrimary
                        offsetX: 39
                        offsetY: 0
                        anchors.top: parent.top
                        visible: Settings.settings.showCorners
                    }
                }
            }
        }
    }

    // This alias exposes the visual bar's visibility to the outside world
    property alias visible: barRootItem.visible
}
