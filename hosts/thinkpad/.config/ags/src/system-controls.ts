import { hyprland } from "./services";

const systemButtons = [
  {
    name: "button-lock",
    child: Widget.Label(" 󰍁 "),
    onClicked: () =>
      execSystemCommand(
        Utils.exec(
          "swaylock -f -c 002266 -i /home/doppler/Pictures/PETALS-2023-09-28T03_11_47.373Z.png",
        ),
      ),
  },
  {
    name: "button-suspend",
    child: Widget.Label(" ⏾ "),
    onClicked: () => execSystemCommand(Utils.exec("systemctl suspend")),
  },
  {
    name: "button-logout",
    child: Widget.Label(" 󰿅 "),
    onClicked: () => execSystemCommand(hyprland.messageAsync("dispatch exit")),
  },
  {
    name: "button restart",
    child: Widget.Label("  "),
    onClicked: () => execSystemCommand(Utils.exec("systemctl reboot")),
  },
  {
    name: "button-poweroff",
    child: Widget.Label("  "),
    onClicked: () => execSystemCommand(Utils.exec("systemctl poweroff")),
  },
].map(({ name, child, onClicked }) =>
  Widget.Button({
    name,
    child,
    onClicked,
    onHover: self => self.grab_focus(),
  }),
);

const SystemControls = Widget.Window({
  name: "system-controls",
  layer: "overlay",
  exclusivity: "ignore",
  keymode: "exclusive",
  anchor: ["top", "bottom", "left", "right"],
  visible: false,
  child: Widget.Box({
    name: "system-box",
    spacing: 10,
    hpack: "center",
    vpack: "center",
    children: systemButtons,
  }),
}).keybind("Escape", () => App.closeWindow("system-controls"));

const execSystemCommand = cmd => {
  App.closeWindow("system-controls");
  cmd();
};

export const openSystemControls = () => {
  App.openWindow("system-controls");
  systemButtons[0].grab_focus();
  let focusedButton = systemButtons.find(b => b.has_focus);
  if (focusedButton) focusedButton.class_name = "focused";
};
globalThis.openSystemControls = openSystemControls;

export default SystemControls;
