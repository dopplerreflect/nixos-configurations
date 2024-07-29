import { network } from "./services";
const Wifi = () =>
  Widget.Box({
    class_name: "wifi",
    children: [
      Widget.Icon({
        icon: network.wifi.bind("icon_name"),
      }),
      Widget.Label({
        label: network.wifi.bind("ssid").as(ssid => ssid || "Unknown"),
      }),
    ],
  });

export default Wifi;
