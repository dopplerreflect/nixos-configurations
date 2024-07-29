const hyprland = await Service.import("hyprland");
import SystemControls from "./system-controls";
import Bar from "./bar";

let css = `${App.configDir}/style.css`;

Utils.monitorFile(css, function () {
  App.resetCss();
  App.applyCss(css);
});

App.config({
  style: "./style.css",
  windows: hyprland.monitors.length === 2 ? [Bar(0), Bar(1)] : [Bar(0)],
});

App.addWindow(SystemControls);

export {};
