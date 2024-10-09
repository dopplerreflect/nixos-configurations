import Workspaces from "./workspaces";
import ClientTitle from "./client-title";
import Clock from "./clock";
import Volume from "./volume";
import Wifi from "./wifi";
import PowerButton from "./power-button";

function Left(monitor: number) {
  return Widget.Box({
    class_name: "left",
    spacing: 8,
    children: [Workspaces(monitor)],
  });
}

function Center() {
  return Widget.Box({
    spacing: 8,
    children: [ClientTitle()],
  });
}

function Right() {
  return Widget.Box({
    hpack: "end",
    class_name: "right",
    spacing: 8,
    children: [Volume(), Wifi(), Clock(), PowerButton()],
  });
}

const Bar = (monitor: number) =>
  Widget.Window({
    monitor,
    name: `bar${monitor}`,
    class_name: "bar",
    anchor: ["top", "left", "right"],
    margins: [0, 5, 0, 5],
    exclusivity: "ignore",
    visible: false,
    child: Widget.CenterBox({
      start_widget: Left(monitor),
      center_widget: Center(),
      end_widget: Right(),
    }),
  });

export default Bar;
