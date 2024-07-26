const hyprland = await Service.import("hyprland");
const audio = await Service.import("audio");

const time = Variable("", {
  poll: [1000, 'date "+%a %b %d %H:%M:%S"'],
});

function Workspaces(monitor?: number) {
  const activeId = hyprland.active.workspace.bind("id");
  const workspaces = [...Array(10).keys()]
    .map(k => k + 1)
    .map(id =>
      Widget.Button({
        on_clicked: () => hyprland.messageAsync(`dispatch workspace ${id}`),
        child: Widget.Label(`${id}`),
        class_name: activeId.as(i => `${i === id ? "focused" : ""}`),
      }),
    );

  return Widget.Box({
    class_name: "workspaces",
    children: workspaces,
  });
}

function ClientTitle() {
  return Widget.Label({
    class_name: "client-title",
    label: hyprland.active.client.bind("title"),
  });
}

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

  return Widget.Box({
    class_name: "volume",
    children: [
      icon,
      Widget.Label({
        label: ` ${audio.speaker.volume} % `,
      }),
    ],
  });
}
function Left() {
  return Widget.Box({
    class_name: "left",
    spacing: 8,
    children: [Workspaces()],
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
    children: [Volume(), Clock()],
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
      start_widget: Left(),
      center_widget: Center(),
      end_widget: Right(),
    }),
  });

App.config({
  style: "./style.css",
  windows: [Bar(1)],
});

let css = `${App.configDir}/style.css`;

Utils.monitorFile(css, function () {
  App.resetCss();
  App.applyCss(css);
});

export {};
