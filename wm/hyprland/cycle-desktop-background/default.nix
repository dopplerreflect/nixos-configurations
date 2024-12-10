{pkgs, ...}: {
  home = {
    packages = [pkgs.bun];
    file."./.local/bin/cycle-desktop-background".source = ./cycle-desktop-background;
  };

  systemd.user.services = {
    cycle-desktop-background = {
      Unit = {
        Description = "Cycle Desktop Backgrounds";
        PartOf = ["hyprland-session.target"];
        After = ["hyprland-session.target"];
        ConditionEnvironment = "WAYLAND_DISPLAY";
      };
      Service = {
        Type = "simple";
        ExecStart = "/home/doppler/.local/bin/cycle-desktop-background --frequency 300000";
        Restart = "on-failure";
      };
      Install = {
        WantedBy = ["hyprland-session.target"];
      };
    };
  };
}
