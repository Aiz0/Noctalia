import QtQuick
import Quickshell
import Quickshell.Services.UPower
import QtQuick.Layouts
import qs.Components
import qs.Settings
import "../../Helpers/Time.js" as Time

Item {
    id: batteryWidget

    // Test mode
    property bool testMode: false
    property int testPercent: 49
    property bool testCharging: true

    property var battery: UPower.displayDevice
    property bool isReady: testMode ? true : (battery && battery.ready && battery.isLaptopBattery && battery.isPresent)
    property real percent: testMode ? testPercent : (isReady ? (battery.percentage * 100) : 0)
    property bool charging: testMode ? testCharging : (isReady ? battery.state === UPowerDeviceState.Charging : false)
    property bool show: isReady && percent > 0

    // Choose icon based on charge and charging state
    function batteryIcon() {
        if (!show)
            return "";

        if (charging) {
            // Hardcoded battery symbols
            if (percent >= 95)
                return "battery_charging_full";
            if (percent >= 85)
                return "battery_charging_90";
            if (percent >= 75)
                return "battery_charging_80";
            if (percent >= 55)
                return "battery_charging_60";
            if (percent >= 45)
                return "battery_charging_50";
            if (percent >= 25)
                return "battery_charging_30";
            if (percent >= 0)
                return "battery_charging_20";
        }

        if (percent >= 95)
            return "battery_full";

        // Hardcoded battery symbols
        if (percent >= 85)
            return "battery_6_bar";
        if (percent >= 70)
            return "battery_5_bar";
        if (percent >= 55)
            return "battery_4_bar";
        if (percent >= 40)
            return "battery_3_bar";
        if (percent >= 25)
            return "battery_2_bar";
        if (percent >= 10)
            return "battery_1_bar";
        if (percent >= 0)
            return "battery_0_bar";
    }

    visible: testMode || (isReady && battery.isLaptopBattery)
    width: pill.width
    height: pill.height

    PillIndicator {
        id: pill
        icon: batteryWidget.batteryIcon()
        text: Math.round(batteryWidget.percent) + "%"
        pillColor: Theme.surfaceVariant
        iconCircleColor: Theme.accentPrimary
        iconTextColor: Theme.backgroundPrimary
        textColor: charging ? Theme.accentPrimary : Theme.textPrimary
        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: {
                pill.showDelayed();
                batteryTooltip.tooltipVisible = true;
            }
            onExited: {
                pill.hide();
                batteryTooltip.tooltipVisible = false;
            }
        }
        StyledTooltip {
            id: batteryTooltip
            positionAbove: false
            text: {
                let lines = [];
                if (!batteryWidget.isReady) {
                    return "";
                }

                if (batteryWidget.battery.timeToEmpty > 0) {
                    lines.push("Time left: " + Time.formatVagueHumanReadableTime(batteryWidget.battery.timeToEmpty));
                }

                if (batteryWidget.battery.timeToFull > 0) {
                    lines.push("Time until full: " + Time.formatVagueHumanReadableTime(batteryWidget.battery.timeToFull));
                }

                if (batteryWidget.battery.changeRate !== undefined) {
                    const rate = batteryWidget.battery.changeRate;
                    if (rate > 0) {
                        lines.push(batteryWidget.charging ? "Charging rate: " + rate.toFixed(2) + " W" : "Discharging rate: " + rate.toFixed(2) + " W");
                    } else if (rate < 0) {
                        lines.push("Discharging rate: " + Math.abs(rate).toFixed(2) + " W");
                    } else {
                        lines.push("Estimating...");
                    }
                } else {
                    lines.push(batteryWidget.charging ? "Charging" : "Discharging");
                }

                if (batteryWidget.battery.healthPercentage !== undefined && batteryWidget.battery.healthPercentage > 0) {
                    lines.push("Health: " + Math.round(batteryWidget.battery.healthPercentage) + "%");
                }
                return lines.join("\n");
            }
            tooltipVisible: false
            targetItem: pill
            delay: 1500
        }
    }
}
