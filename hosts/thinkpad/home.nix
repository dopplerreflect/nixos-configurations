{ config, pkgs, lib, ... }:

{
  home.username = "doppler";
  home.homeDirectory = "/home/doppler";

  home.packages = with pkgs; [
    alacritty
    bc
    bitwarden
    brave
    brightnessctl
    btop
    easyeffects
    fastfetch # like neofetch
    ffmpeg
    ffmpegthumbnailer
    file
    firefox
    freefilesync
    gimp
    gnome.dconf-editor
    gnome.nautilus
    gnome3.gnome-tweaks
    googleearth-pro
    gqrx
    grimblast
    heroku
    i3status-rust
    imagemagick
    imv
    inkscape
    jq
    mako
    miller # miller text parser thing https://miller.readthedocs.io/en/latest/
    morewaita-icon-theme
    mpv
    nmap
    nodejs
    nwg-bar
    nwg-launchers
    pavucontrol
    pulseaudioFull
    python3
    realvnc-vnc-viewer
    ripgrep
    rpi-imager
    rtl_433
    rtl-sdr
    slurp
    sqlite-interactive
    sway-contrib.grimshot
    swaybg
    swayidle
    swaylock
    swww
    unzip
    virt-manager
    virt-viewer
    vscode
    wavemon
    waybar
    wget
    wl-clipboard
    wlroots
    wofi
    yarn
    zstd
  ];
  
  home.file = {
    ".config/alacritty/alacritty.toml".text = builtins.readFile ./config/alacritty/alacritty.toml;
  };

  wayland.windowManager = {
    sway = {
      enable = true;
      config = null;
      checkConfig = false;
      systemd.xdgAutostart = true;
      wrapperFeatures.gtk = true;
      extraConfig = lib.fileContents ./config/sway/config;
    };
    hyprland = {
      enable = true;
      extraConfig = lib.fileContents ./config/hypr/hyprland.conf;
    };
  };
 
  # tried this from https://www.reddit.com/r/NixOS/comments/18hdool/how_do_i_set_a_global_dark_theme_and_configure_gtk/
  # trying to get dark theme and all icons
  # don't think it helped.
  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome.gnome-themes-extra;
    };
  };

  home.stateVersion = "24.05";

}
