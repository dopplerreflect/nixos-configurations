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
    grimblast
    hypridle
    hyprlock
    libnotify
    slurp
    swww
    wl-clipboard
    wlroots
    xdg-desktop-portal-hyprland
  ];
}