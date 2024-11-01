{ pkgs, lib, ... }:

{
  wayland.windowManager = {
    hyprland = {
      enable = true;
      extraConfig = lib.fileContents ./hyprland.conf;
    };
  };

  home = {
    packages = with pkgs; [
      bc
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
    file = {
      "./.local/bin/hyprscale".source = ./hyprscale;
    };
  };

  xdg.configFile = {
    "hypr/hypridle.conf".source = ./hypridle.conf;
    "hypr/hyprlock.conf".source = ./hyprlock.conf;
  };
}
