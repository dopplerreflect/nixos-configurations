const hyprland = await Service.import("hyprland");
const audio = await Service.import("audio");
const network = await Service.import("network");

type WorkspaceList = Map<number, string | null>[];
const workspaceList: WorkspaceList =
  hyprland.monitors.length === 2
    ? [
        new Map([
          [1, ""],
          [3, ""],
        ]),
        new Map([
          [2, ""],
          [4, ""],
          [5, ""],
          [6, null],
          [7, null],
          [8, null],
          [9, null],
          [10, null],
        ]),
      ]
    : [
        new Map([
          [1, ""],
          [2, ""],
          [3, ""],
          [4, ""],
          [5, ""],
          [6, null],
          [7, null],
          [8, null],
          [9, null],
          [10, null],
        ]),
      ];

function Workspaces(monitor: number) {
  const activeId = hyprland.active.workspace.bind("id");
  const workspaces = [...workspaceList[monitor]].map(([id, label]) => {
    return Widget.Button({
      on_clicked: () => hyprland.messageAsync(`dispatch workspace ${id}`),
      child: Widget.Label(label ? ` ${id}:${label}` : `${id}`),
      class_name: activeId.as(i => `${i === id ? "focused" : ""}`),
    });
  });

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
        label: network.wifi.bind("ssid").as(ssid => ssid || "Unknow"),
      }),
    ],
  });
}

const PowerButton = () =>
  Widget.Button({
    on_clicked: () => (systemWindow.visible = !systemWindow.visible),
    child: Widget.Label("⏻"),
    class_name: "power-button",
  });

const systemButtons = [
  {
    child: Widget.Label(" 󰍁 "),
    onClicked: () =>
      execSystemCommand(
        Utils.exec(
          "swaylock -f -c 002266 -i /home/doppler/Pictures/PETALS-2023-09-28T03_11_47.373Z.png",
        ),
      ),
  },
  {
    child: Widget.Label(" ⏾ "),
    onClicked: () => execSystemCommand(Utils.exec("systemctl suspend")),
  },
  {
    child: Widget.Label(" 󰿅 "),
    onClicked: () => execSystemCommand(hyprland.messageAsync("dispatch exit")),
  },
  {
    child: Widget.Label("  "),
    onClicked: () => execSystemCommand(Utils.exec("systemctl reboot")),
  },
  {
    child: Widget.Label("  "),
    onClicked: () => execSystemCommand(Utils.exec("systemctl poweroff")),
  },
];

export const systemWindow = Widget.Window({
  name: "system-controls",
  layer: "overlay",
  exclusivity: "ignore",
  keymode: "exclusive",
  anchor: ["top", "bottom", "left", "right"],
  child: Widget.Box({
    class_name: "system-box",
    spacing: 10,
    hpack: "center",
    vpack: "center",
    vexpand: false,
    children: systemButtons.map(({ child, onClicked }) =>
      Widget.Button({
        child,
        onClicked,
        on_hover: self => (self.class_name = "focused"),
        on_hover_lost: self => (self.class_name = ""),
      }),
    ),
  }),
  visible: false,
}).keybind("Escape", self => {
  self.visible = false;
});

const execSystemCommand = cmd => {
  systemWindow.visible = false;
  cmd();
};
// so we can target this with "ags -r systemWindow.visible = true"
globalThis.systemWindow = systemWindow;

const System = () => systemWindow;

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

let css = `${App.configDir}/style.css`;

Utils.monitorFile(css, function () {
  App.resetCss();
  App.applyCss(css);
});

App.config({
  style: "./style.css",
  windows:
    hyprland.monitors.length === 2
      ? [Bar(0), Bar(1), System()]
      : [Bar(0), System()],
});

export {};
