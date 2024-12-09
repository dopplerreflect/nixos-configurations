{
  pkgs,
  lib,
  ...
}: {
  wayland.windowManager = {
    hyprland = {
      enable = true;
      extraConfig = lib.fileContents ./hyprland.conf;
      # xwayland.enable = false; # this causes cache.nixos.org miss and thus has to build from source
    };
  };

  home = {
    packages = with pkgs; [
      bc
      brightnessctl
      bun
      hypridle
      hyprlock
      hyprshot
      libnotify
      swaynotificationcenter
      swww
      wl-clipboard
      wlroots
      xdg-desktop-portal-hyprland
    ];
    file = {
      "./.local/bin/hyprscale".source = ./hyprscale;
    };
  };

  xdg.configFile = {
    "hypr/hypridle.conf".source = ./hypridle.conf;
    "hypr/hyprlock.conf".source = ./hyprlock.conf;
    "hypr/parts" = {
      source = ./parts;
      recursive = true;
    };
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
        ExecStart = "/home/doppler/.local/bin/cycle-desktop-backgrounds.ts --frequency 300000";
        Restart = "on-failure";
      };
      Install = {
        WantedBy = ["hyprland-session.target"];
      };
    };
  };
}
