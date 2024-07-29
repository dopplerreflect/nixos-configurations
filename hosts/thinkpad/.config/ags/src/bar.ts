import { audio, hyprland, network } from "./services";
import Workspaces from "./workspaces";

function ClientTitle() {
  return Widget.Label({
    class_name: "client-title",
    label: hyprland.active.client.bind("title"),
  });
}

const time = Variable("", {
  poll: [1000, 'date "+%a %b %d %H:%M:%S"'],
});

function Clock() {
  return Widget.Label({
    class_name: "clock",
    label: time.bind(),
  });
}

function Volume() {
  const icons = {
    101: "overamplified",
    67: "high",
    34: "medium",
    1: "low",
    0: "muted",
  };

  function getIcon() {
    const index = audio.speaker.is_muted
      ? 0
      : ([101, 67, 34, 1, 0].find(
          threshold => threshold <= audio.speaker.volume * 100,
        ) as number);
    return `audio-volume-${icons[index]}-symbolic`;
  }

  const icon = Widget.Icon({
    icon: Utils.watch(getIcon(), audio.speaker, getIcon),
  });

  const label = Widget.Label().hook(audio.speaker, self => {
    const vol = Math.round(audio.speaker.volume * 100);
    self.label = `${vol}%`;
  });

  return Widget.Box({
    class_name: "volume",
    children: [icon, label],
  });
}

function Wifi() {
  return Widget.Box({
    class_name: "wifi",
    children: [
      Widget.Icon({
        icon: network.wifi.bind("icon_name"),
      }),
      Widget.Label({
        label: network.wifi.bind("ssid").as(ssid => ssid || "Unknown"),
      }),
    ],
  });
}

const PowerButton = () =>
  Widget.Button({
    on_clicked: () => openSystemControls(),
    child: Widget.Label("⏻"),
    class_name: "power-button",
  });

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
    anchor: ["bottom", "left", "right"],
    margins: [0, 10, 5, 10],
    exclusivity: "exclusive",
    child: Widget.CenterBox({
      start_widget: Left(monitor),
      center_widget: Center(),
      end_widget: Right(),
    }),
  });

export default Bar;
