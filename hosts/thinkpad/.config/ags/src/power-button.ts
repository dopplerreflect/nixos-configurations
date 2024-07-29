const PowerButton = () =>
  Widget.Button({
    on_clicked: () => openSystemControls(),
    child: Widget.Label("⏻"),
    class_name: "power-button",
  });

export default PowerButton;
