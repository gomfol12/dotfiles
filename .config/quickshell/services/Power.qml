pragma Singleton

import Quickshell
import Quickshell.Services.UPower

Singleton {
    id: root

    readonly property var battery: UPower.displayDevice
    readonly property bool hasBattery: battery !== null && battery.isPresent
    readonly property real percentage: hasBattery ? battery.percentage : 0
    readonly property bool critical: hasBattery && percentage < 10
}
