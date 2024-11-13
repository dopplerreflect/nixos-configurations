import { hyprland } from "./services";

const systemButtons = [
  {
    name: "button-suspend",
    tooltipText: "Suspend",
    child: Widget.Label(" ⏾ "),
    onClicked: () => execSystemCommand(Utils.exec("systemctl suspend")),
  },
  {
    name: "button-lock",
    tooltipText: "Lock",
    child: Widget.Label(" 󰍁 "),
    onClicked: () => execSystemCommand(Utils.exec("hyprlock")),
  },
  {
    name: "button-logout",
    tooltipText: "Log Out",
    child: Widget.Label(" 󰿅 "),
    onClicked: () => execSystemCommand(hyprland.messageAsync("dispatch exit")),
  },
  {
    name: "button restart",
    tooltipText: "Restart",
    child: Widget.Label("  "),
    onClicked: () => execSystemCommand(Utils.exec("systemctl reboot")),
  },
  {
    name: "button-poweroff",
    tooltipText: "Power Off",
    child: Widget.Label("  "),
    onClicked: () => execSystemCommand(Utils.exec("systemctl poweroff")),
  },
].map(({ name, tooltipText, child, onClicked }) =>
  Widget.Button({
    name,
    tooltipText,
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
