import { network } from "./services";

const Wifi = () => {
  const isEthernetConnected = network.wired.internet === "connected";
  const wifiBox = Widget.Box({
    class_name: "wifi",
    children: [
      Widget.Icon({
        icon: isEthernetConnected
          ? network.wired.bind("icon_name")
          : network.wifi.bind("icon_name"),
      }),
      Widget.Label({
        label: isEthernetConnected
          ? "Wired"
          : network.wifi.bind("ssid").as(ssid => ssid || "Unknown"),
      }),
    ],
  });

  return Widget.Button({
    child: wifiBox,
    onClicked: () => Utils.exec("kitty -e nmtui"),
  });
};
export default Wifi;
