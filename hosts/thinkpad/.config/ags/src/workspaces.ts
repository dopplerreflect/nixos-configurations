import { hyprland } from "./services";

type WorkspaceList = Map<number, string | null>[];
const workspaceList: WorkspaceList =
  hyprland.monitors.length === 2
    ? [
        new Map([
          [1, ""],
          [3, ""],
        ]),
        new Map([
          [2, ""],
          [4, ""],
          [5, ""],
          [6, null],
          [7, null],
          [8, null],
          [9, null],
          [10, null],
        ]),
      ]
    : [
        new Map([
          [1, ""],
          [2, ""],
          [3, ""],
          [4, ""],
          [5, ""],
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
