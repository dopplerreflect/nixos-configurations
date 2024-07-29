import { network } from "./services";
const Wifi = () => {
  const wifiBox = Widget.Box({
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

  return Widget.Button({
    child: wifiBox,
    onClicked: () => Utils.exec("kitty -e nmtui"),
  });
};
export default Wifi;
