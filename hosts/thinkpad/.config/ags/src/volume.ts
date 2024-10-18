import { audio } from "./services";

const icons = {
  101: "overamplified",
  67: "high",
  34: "medium",
  1: "low",
  0: "muted",
};

function getIcon() {
  const index = audio.speaker.is_muted
    ? 0
    : ([101, 67, 34, 1, 0].find(
        threshold => threshold <= audio.speaker.volume * 100,
      ) as number);
  return `audio-volume-${icons[index]}-symbolic`;
}

const icon = Widget.Icon({
  icon: Utils.watch(getIcon(), audio.speaker, getIcon),
});

const label = Widget.Label().hook(audio.speaker, self => {
  const vol = Math.round(audio.speaker.volume * 100);
  self.label = `${vol}%`;
});

const speakerBox = Widget.Box({
  class_name: "volume",
  children: [icon, label],
});

const Volume = () => {
  return Widget.Button({
    child: speakerBox,
    onClicked: () => (audio.speaker.is_muted = !audio.speaker.is_muted),
  });
};

export default Volume;

export const VolumePopup = Widget.Window({
  name: "VolumePopup",
  visible: false,
  child: Widget.Box({
    children: [
      Widget.Icon({
        icon: Utils.watch(getIcon(), audio.speaker, getIcon),
      }),
      Widget.Label().hook(audio.speaker, self => {
        const vol = Math.round(audio.speaker.volume * 100);
        self.label = `${vol}%`;
      }),
    ],
  }),
});

let timeout;
export const openVolumePopup = () => {
  const window = App.getWindow("VolumePopup");
  if (window && !window.visible) {
    App.openWindow("VolumePopup");
    const id = Utils.timeout(2000, () => {
      App.toggleWindow("VolumePopup");
    });
  }
};
globalThis.openVolumePopup = openVolumePopup;
