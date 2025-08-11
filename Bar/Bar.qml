import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import qs.Bar.Modules
import qs.Components
import qs.Helpers
import qs.Services
import qs.Settings
import qs.Widgets
import qs.Widgets.Notification
import qs.Widgets.SidePanel

// Main bar component - creates panels on selected monitors with widgets and corners
Scope {
    id: rootScope

    property var shell
    property alias visible: barRootItem.visible

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
                        width: 36 * Theme.scale(panel.screen)
                        height: parent.height
                        color: Theme.backgroundPrimary
                        anchors.top: parent.top
                        anchors.left: parent.left
                    }

                    Column {
                        id: leftWidgetsRow
                        anchors.horizontalCenter: barBackground.horizontalCenter
                        anchors.top: barBackground.top
                        anchors.topMargin: 18 * Theme.scale(panel.screen)
                        spacing: 12 * Theme.scale(panel.screen)

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
                        anchors.bottomMargin: 18 * Theme.scale(panel.screen)
                        spacing: 12 * Theme.scale(panel.screen)

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

                        NotificationIcon {
                            anchors.horizontalCenter: parent.horizontalCenter
                            shell: rootScope.shell
                        }

                        Wifi {
                            anchors.horizontalCenter: parent.horizontalCenter
                        }

                        Bluetooth {
                            anchors.horizontalCenter: parent.horizontalCenter
                        }

                        Battery {
                            id: widgetsBattery
                            anchors.horizontalCenter: parent.horizontalCenter
                        }

                        Brightness {
                            id: widgetsBrightness

                            screen: modelData
                            anchors.horizontalCenter: parent.horizontalCenter
                        }

                        Volume {
                            id: widgetsVolume

                            shell: rootScope.shell
                            anchors.horizontalCenter: parent.horizontalCenter
                        }

                        ClockWidget {
                            screen: modelData
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }
                }

                Loader {
                    active: Settings.settings.showCorners && (Settings.settings.barMonitors.includes(modelData.name) || (Settings.settings.barMonitors.length === 0))

                    sourceComponent: Item {
                        PanelWindow {
                            id: topLeftPanel

                            anchors.top: true
                            anchors.left: true
                            color: "transparent"
                            screen: modelData
                            margins.left: 36 * Theme.scale(screen) - 1
                            WlrLayershell.exclusionMode: ExclusionMode.Ignore
                            WlrLayershell.layer: WlrLayer.Top
                            WlrLayershell.namespace: "swww-daemon"
                            aboveWindows: false
                            implicitHeight: 24

                            Corner {
                                id: topLeftCorner

                                position: "bottomleft"
                                size: 1.3
                                fillColor: (Theme.backgroundPrimary !== undefined && Theme.backgroundPrimary !== null) ? Theme.backgroundPrimary : "#222"
                                offsetX: -39
                                offsetY: 0
                                anchors.top: parent.top
                            }
                        }

                        PanelWindow {
                            id: topRightPanel

                            anchors.top: true
                            anchors.right: true
                            color: "transparent"
                            screen: modelData
                            WlrLayershell.exclusionMode: ExclusionMode.Ignore
                            WlrLayershell.layer: WlrLayer.Top
                            WlrLayershell.namespace: "swww-daemon"
                            aboveWindows: false
                            implicitHeight: 24

                            Corner {
                                id: topRightCorner

                                position: "bottomright"
                                size: 1.3
                                fillColor: (Theme.backgroundPrimary !== undefined && Theme.backgroundPrimary !== null) ? Theme.backgroundPrimary : "#222"
                                offsetX: 39
                                offsetY: 0
                                anchors.top: parent.top
                            }
                        }

                        PanelWindow {
                            id: bottomLeftPanel

                            anchors.bottom: true
                            anchors.left: true
                            color: "transparent"
                            screen: modelData
                            margins.left: 36 * Theme.scale(screen) - 1
                            WlrLayershell.exclusionMode: ExclusionMode.Ignore
                            WlrLayershell.layer: WlrLayer.Top
                            WlrLayershell.namespace: "swww-daemon"
                            aboveWindows: false
                            implicitHeight: 24

                            Corner {
                                id: bottomLeftCorner

                                position: "topleft"
                                size: 1.3
                                fillColor: Theme.backgroundPrimary
                                offsetX: -39
                                offsetY: 0
                                anchors.top: parent.top
                            }
                        }

                        PanelWindow {
                            id: bottomRightPanel

                            anchors.bottom: true
                            anchors.right: true
                            color: "transparent"
                            screen: modelData
                            WlrLayershell.exclusionMode: ExclusionMode.Ignore
                            WlrLayershell.layer: WlrLayer.Top
                            WlrLayershell.namespace: "swww-daemon"
                            aboveWindows: false
                            implicitHeight: 24

                            Corner {
                                id: bottomRightCorner

                                position: "topright"
                                size: 1.3
                                fillColor: Theme.backgroundPrimary
                                offsetX: 39
                                offsetY: 0
                                anchors.top: parent.top
                            }
                        }
                    }
                }
            }
        }
    }
}
