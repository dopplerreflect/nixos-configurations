{ config, pkgs, lib, ... }:

{
  wayland.windowManager = {
    sway = {
      enable = true;
      config = null;
      checkConfig = false;
      systemd.xdgAutostart = true;
      wrapperFeatures.gtk = true;
      extraConfig = lib.fileContents ./.config/sway/config;
    };
  };

  home.packages = with pkgs; [
    brightnessctl
    i3status-rust
    mako
    nwg-bar
    nwg-launchers
    slurp
    sway-contrib.grimshot
    swaybg
    swayidle
    swaylock
    waybar
    wlroots
  ];

  home.file = {
    ".config/swayidle/config".source = ./.config/swayidle/config;
    ".config/i3status-rust/config.toml".source = ./.config/i3status-rust/config.toml;
    ".config/mako/config".source = ./.config/mako/config;
  };
}
