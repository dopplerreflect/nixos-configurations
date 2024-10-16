const time = Variable("", {
  poll: [1000, 'date "+%a %b %d %H:%M:%S"'],
});

const Clock = () =>
  Widget.Button({
    child: Widget.Label({
      class_name: "clock",
      label: time.bind(),
    }),
    onClicked: () => App.openWindow("clock-window"),
  });

export const ClockWindow = Widget.Window({
  name: "clock-window",
  layer: "overlay",
  keymode: "on-demand",
  visible: false,
  child: Widget.Label({
    class_name: "clock",
    label: time.bind(),
  }),
}).keybind("Escape", () => App.closeWindow("clock-window"));

export default Clock;
