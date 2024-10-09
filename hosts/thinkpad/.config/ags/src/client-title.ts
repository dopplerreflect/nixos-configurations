import { hyprland } from "./services";
const ClientTitle = () =>
  Widget.Label({
    class_name: "client-title",
    label: hyprland.active.client
      .bind("title")
      .as(title => `${title}`.slice(0, 110)),
  });

export default ClientTitle;
