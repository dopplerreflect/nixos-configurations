{ config, pkgs, lib, ... }:

{
  wayland.windowManager = {
    hyprland = {
      enable = true;
      extraConfig = lib.fileContents ./hyprland.conf;
    };
  };

  home.packages = with pkgs; [
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

  xdg.configFile = {
    "hypr/hypridle.conf".source = ./hypridle.conf;
    "hypr/hyprlock.conf".source = ./hyprlock.conf;
  };
}
