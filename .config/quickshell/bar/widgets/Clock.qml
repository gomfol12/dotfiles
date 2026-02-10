import QtQuick
import qs.services

Text {
    font.pixelSize: Config.font.size
    font.family: Config.font.family
    color: Colors.foreground

    text: Time.time
}
