import { hyprland } from "./services";
import Bar from "./bar";
import SystemControls from "./system-controls";
import AppLauncher from "./app-launcher";
import { ClockWindow, SmallClockWindow } from "./clock";

let css = `${App.configDir}/style.css`;

Utils.monitorFile(css, function () {
  App.resetCss();
  App.applyCss(css);
});

App.config({
  style: "./style.css",
  windows: hyprland.monitors.length === 2 ? [Bar(0), Bar(1)] : [Bar(0)],
});

App.addWindow(ClockWindow);
App.addWindow(SmallClockWindow);
App.addWindow(SystemControls);
App.addWindow(AppLauncher);
export {};
