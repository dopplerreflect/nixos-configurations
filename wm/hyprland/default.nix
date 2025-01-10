{
  pkgs,
  lib,
  ...
}:
{
  wayland.windowManager = {
    hyprland = {
      enable = true;
      extraConfig = lib.fileContents ./hyprland.conf;
      # xwayland.enable = false; # this causes cache.nixos.org miss and thus has to build from source
    };
  };

  home = {
    packages = with pkgs; [
      brightnessctl
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
  };

  imports = [
    ./cycle-desktop-background
    ./hyprscale
    ./toggle-hypridle
  ];

  xdg.configFile = {
    "hypr/hypridle.conf".source = ./hypridle.conf;
    "hypr/hyprlock.conf".source = ./hyprlock.conf;
    "hypr/parts" = {
      source = ./parts;
      recursive = true;
    };
  };
}
