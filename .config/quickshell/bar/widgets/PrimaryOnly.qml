pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import qs.services

Loader {
    id: loader

    property bool show: true

    active: show
    visible: active

    Layout.preferredHeight: Config.bar.boxHeight
    Layout.topMargin: Config.bar.boxMargin
    Layout.bottomMargin: Config.bar.boxMargin
    Layout.preferredWidth: item ? (item.Layout.preferredWidth >= 0 ? item.Layout.preferredWidth : item.implicitWidth) : 0
}
