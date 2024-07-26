"use strict";
const time = Variable("", {
    poll: [
        1000,
        function () {
            return Date().toLocaleUpperCase();
        },
    ],
});
const Bar = (monitor) => Widget.Window({
    monitor,
    name: `bar${monitor}`,
    anchor: ["bottom", "left", "right"],
    margins: [0, 10, 5, 10],
    exclusivity: "exclusive",
    child: Widget.CenterBox({
        start_widget: Widget.Label({
            name: "start",
            hpack: "start",
            label: "Welcome to AGS!",
        }),
        center_widget: Widget.Label({
            name: "center",
            hpack: "center",
            label: "CENTER",
        }),
        end_widget: Widget.Label({
            name: "center",
            hpack: "end",
            label: time.bind(),
        }),
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
