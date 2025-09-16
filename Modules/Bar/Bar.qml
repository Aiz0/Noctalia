import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.UPower
import qs.Commons
import qs.Services
import qs.Widgets
import qs.Modules.Notification

Variants {
  model: Quickshell.screens

  delegate: Loader {
    id: root

    required property ShellScreen modelData
    property real scaling: ScalingService.getScreenScale(modelData)

    Connections {
      target: ScalingService
      function onScaleChanged(screenName, scale) {
        if ((modelData !== null) && (screenName === modelData.name)) {
          scaling = scale
        }
      }
    }

    active: Settings.isLoaded && modelData && modelData.name ? (Settings.data.bar.monitors.includes(modelData.name) || (Settings.data.bar.monitors.length === 0)) : false

    sourceComponent: PanelWindow {
      screen: modelData || null

      WlrLayershell.namespace: "noctalia-bar"

      implicitWidth: Math.round(Style.barHeight * scaling)
      color: Color.transparent

      anchors {
        left: Settings.data.bar.position === "top"
        right: Settings.data.bar.position === "bottom"
        top: true
        bottom: true
      }

      // Floating bar margins - only apply when floating is enabled
      margins {
        top: Settings.data.bar.floating ? Settings.data.bar.marginVertical * Style.marginXL : 0
        bottom: Settings.data.bar.floating ? Settings.data.bar.marginVertical * Style.marginXL : 0
        left: Settings.data.bar.floating ? Settings.data.bar.marginHorizontal * Style.marginXL : 0
        right: Settings.data.bar.floating ? Settings.data.bar.marginHorizontal * Style.marginXL : 0
      }

      Item {
        anchors.fill: parent
        clip: true

        // Background fill
        Rectangle {
          id: bar

          anchors.fill: parent
          color: Qt.alpha(Color.mSurface, Settings.data.bar.backgroundOpacity)

          // Floating bar rounded corners
          radius: Settings.data.bar.floating ? Style.radiusL : 0
        }

        // ------------------------------
        // Left Section - Dynamic Widgets
        Column {
          id: leftSection
          objectName: "leftSection"

          height: parent.height
          anchors.top: parent.top
          anchors.topMargin: Style.marginS * scaling
          anchors.horizontalCenter: parent.horizontalCenter
          spacing: Style.marginS * scaling

          Repeater {
            model: Settings.data.bar.widgets.left
            delegate: NWidgetLoader {
              widgetId: (modelData.id !== undefined ? modelData.id : "")
              widgetProps: {
                "screen": root.modelData || null,
                "scaling": ScalingService.getScreenScale(screen),
                "widgetId": modelData.id,
                "section": parent.objectName.replace("Section", "").toLowerCase(),
                "sectionWidgetIndex": index,
                "sectionWidgetsCount": Settings.data.bar.widgets.left.length
              }
              anchors.horizontalCenter: parent.horizontalCenter
            }
          }
        }

        // ------------------------------
        // Center Section - Dynamic Widgets
        Column {
          id: centerSection
          objectName: "centerSection"

          width: parent.width
          anchors.horizontalCenter: parent.horizontalCenter
          anchors.verticalCenter: parent.verticalCenter
          spacing: Style.marginS * scaling

          Repeater {
            model: Settings.data.bar.widgets.center
            delegate: NWidgetLoader {
              widgetId: (modelData.id !== undefined ? modelData.id : "")
              widgetProps: {
                "screen": root.modelData || null,
                "scaling": ScalingService.getScreenScale(screen),
                "widgetId": modelData.id,
                "section": parent.objectName.replace("Section", "").toLowerCase(),
                "sectionWidgetIndex": index,
                "sectionWidgetsCount": Settings.data.bar.widgets.center.length
              }
              anchors.horizontalCenter: parent.horizontalCenter
            }
          }
        }

        // ------------------------------
        // Right Section - Dynamic Widgets
        Column {
          id: rightSection
          objectName: "rightSection"

          width: parent.width
          anchors.bottom: bar.bottom
          anchors.bottomMargin: Style.marginS * scaling
          anchors.horizontalCenter: bar.horizontalCenter
          spacing: Style.marginS * scaling

          Repeater {
            model: Settings.data.bar.widgets.right
            delegate: NWidgetLoader {
              widgetId: (modelData.id !== undefined ? modelData.id : "")
              widgetProps: {
                "screen": root.modelData || null,
                "scaling": ScalingService.getScreenScale(screen),
                "widgetId": modelData.id,
                "section": parent.objectName.replace("Section", "").toLowerCase(),
                "sectionWidgetIndex": index,
                "sectionWidgetsCount": Settings.data.bar.widgets.right.length
              }
              anchors.horizontalCenter: parent.horizontalCenter
            }
          }
        }
      }
    }
  }
}
