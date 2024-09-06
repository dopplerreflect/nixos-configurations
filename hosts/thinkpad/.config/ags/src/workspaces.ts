import { hyprland } from "./services";

type WorkspaceList = Map<number, string | null>[];
const workspaceList: WorkspaceList =
  hyprland.monitors.length === 2
    ? [
        new Map([
          [1, null],
          [3, null],
        ]),
        new Map([
          [2, null],
          [4, null],
          [5, null],
          [6, null],
          [7, null],
          [8, null],
          [9, null],
          [10, null],
        ]),
      ]
    : [
        new Map([
          [1, null],
          [2, null],
          [3, null],
          [4, null],
          [5, null],
          [6, null],
          [7, null],
          [8, null],
          [9, null],
          [10, null],
        ]),
      ];

function Workspaces(monitor: number) {
  const activeId = hyprland.active.workspace.bind("id");
  const workspaces = [...workspaceList[monitor]].map(([id, label]) => {
    return Widget.Button({
      on_clicked: () => hyprland.messageAsync(`dispatch workspace ${id}`),
      child: Widget.Label(label ? `${id}:${label}` : `${id}`),
      class_name: activeId.as(i => `${i === id ? "focused" : ""}`),
    });
  });

  return Widget.Box({
    class_name: "workspaces",
    children: workspaces,
  });
}

export default Workspaces;
