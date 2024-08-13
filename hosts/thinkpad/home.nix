{ config, pkgs, lib, ... }:

{
  home.username = "doppler";
  home.homeDirectory = "/home/doppler";

  home.packages = with pkgs; [
    # ags # this is in nix profile instead due to broken upstream build
    adwaita-qt
    bc
    bitwarden
    brave
    btop
    dconf-editor
    # easyeffects # php requirement was failing test on nixos-unstable 7/31/2024
    fastfetch # like neofetch
    ffmpeg
    ffmpegthumbnailer
    file
    firefox
    freefilesync
    gimp
    gnome.gnome-characters
    gnome-tweaks
    googleearth-pro
    gqrx
    gucharmap
    heroku
    imagemagick
    imv
    inkscape
    jq
    kitty
    miller # miller text parser thing https://miller.readthedocs.io/en/latest/
    morewaita-icon-theme
    mpv
    nautilus
    nmap
    nodejs
    pavucontrol
    pulseaudioFull
    python3
    ripgrep
    rpi-imager
    rtl-sdr
    rtl_433
    sqlite-interactive
    unzip
    virt-manager
    virt-viewer
    vscode
    wavemon
    wget
    xfce.thunar
    xfce.thunar-volman
    xfce.tumbler
    xfce.xfconf
    yarn
    yazi
  ];
  
  home.file = {
    ".config/kitty/kitty.conf".source = ./.config/kitty/kitty.conf;
  };

  imports = [
    ./hyprland.nix
    # ./sway.nix
  ];

  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    iconTheme = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
    };
  };

  home.stateVersion = "24.05";

}
