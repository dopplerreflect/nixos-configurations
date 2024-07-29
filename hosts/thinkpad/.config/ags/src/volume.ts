import { audio } from "./services";

const Volume = () => {
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

  return Widget.Box({
    class_name: "volume",
    children: [icon, label],
  });
};

export default Volume;
