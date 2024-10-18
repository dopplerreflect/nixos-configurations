import Bar from "./bar";
import SystemControls from "./system-controls";
import AppLauncher from "./app-launcher";
import { ClockWindow } from "./clock";
import { VolumePopup } from "./volume";

let css = `${App.configDir}/style.css`;

Utils.monitorFile(css, function () {
  App.resetCss();
  App.applyCss(css);
});

App.config({
  style: "./style.css",
  windows: [Bar(), AppLauncher, ClockWindow, SystemControls, VolumePopup],
});

export {};
