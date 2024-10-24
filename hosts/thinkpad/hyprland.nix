{ config, pkgs, lib, ... }:

{
  wayland.windowManager = {
    hyprland = {
      enable = true;
      extraConfig = lib.fileContents ./.config/hypr/hyprland.conf;
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

  home.file = {
    "./.config/hypr" = {
      source = ./.config/hypr;
      recursive = true;
    };
  };
}
