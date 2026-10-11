import QtQuick
import Quickshell
import Quickshell.Io
import qs.Ui

BarWidget {
  id: root
  moduleName: "io.github.aishag80g-stack.hyprland-layout"

  // The CLI ships inside this plugin folder; resolve it from the module path.
  readonly property string cli: {
    var base = Quickshell.env("HOME") + "/.config/omarchy/plugins/" + root.moduleName + "/bin/omarchy-hyprland-layout"
    return base
  }

  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  Process {
    id: restoreProc
    command: ["bash", "-lc", root.cli + " restore-last"]
  }
  Process {
    id: listProc
    command: ["bash", "-lc", root.cli + " list"]
    stdout: StdioCollector {
      id: listOut
      onStreamFinished: root.omarchyNotificationSend("Layouts:\n" + (listOut.text || "none"))
    }
  }

  BarIconButton {
    id: button
    anchors.fill: parent
    bar: root.bar
    text: "󱂬"
    tooltipText: "Restore saved desktop — apps launch in place (right-click: list layouts)"
    onPressed: function(b) {
      if (b === Qt.RightButton) {
        if (!listProc.running) listProc.running = true
      } else {
        if (!restoreProc.running) restoreProc.running = true
      }
    }
  }

  function omarchyNotificationSend(msg) {
    notifyProc.command = ["bash", "-lc", "omarchy-notification-send -g '󱂬' " + JSON.stringify(msg)]
    notifyProc.running = true
  }
  Process { id: notifyProc }
}
