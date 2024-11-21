import Clock from "./clock";
import Volume from "./volume";
import Wifi from "./wifi";

const Bar = () =>
  Widget.Window({
    monitor: 0,
    name: "bar",
    className: "bar",
    visible: false,
    anchor: ["top", "right"],
    child: Widget.Box({
      className: "box",
      spacing: 8,
      children: [Volume(), Wifi(), Clock()],
    }),
  });

export default Bar;
