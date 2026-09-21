pragma Singleton
import Quickshell
import Quickshell.Services.Pipewire
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    readonly property PwNode sink: Pipewire.defaultAudioSink
    readonly property PwNode source: Pipewire.defaultAudioSource

    readonly property real volume: sink?.ready && sink.audio ? sink.audio.volume : 0
    readonly property bool muted: sink?.ready && sink.audio ? sink.audio.muted : true
    readonly property bool micMuted: source?.ready && source.audio ? source.audio.muted : true

    readonly property bool isHeadset: sink !== null && sink.properties["device.bus"] === "usb"

    function volumeIconName() {
        if (!sink || root.muted || root.volume <= 0) {
            if (root.isHeadset) {
                return "headphone-slash";
            }
            return "volume-x";
        }
        if (root.isHeadset) {
            return "headphone";
        }
        if (root.volume < 0.33) {
            return "volume-none";
        }
        if (root.volume < 0.66) {
            return "volume-low";
        }
        return "volume-high";
    }

    function micIconName() {
        return root.micMuted ? "microphone-slash" : "microphone";
    }

    function setVolume(v) {
        if (sink?.ready && sink.audio)
            sink.audio.volume = Math.max(0, Math.min(1, v));
    }
    function toggleMute() {
        if (sink?.ready && sink.audio)
            sink.audio.muted = !sink.audio.muted;
    }
    function toggleMicMute() {
        if (source?.ready && source.audio)
            source.audio.muted = !source.audio.muted;
    }
    function setDefaultSink(node) {
        Pipewire.preferredDefaultAudioSink = node;
    }

    function setDefaultSource(node) {
        Pipewire.preferredDefaultAudioSource = node;
    }

    PwObjectTracker {
        objects: [root.sink, root.source].filter(n => n !== null)
    }
}
