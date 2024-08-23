{ config, pkgs, lib, ... }:

{
  home.username = "doppler";
  home.homeDirectory = "/home/doppler";

  home.packages = with pkgs; [
    # ags # this is in nix profile instead due to broken upstream build
    # adwaita-qt
    bc
    bitwarden
    brave
    btop
    bat
    dconf-editor
    # easyeffects # php requirement was failing test on nixos-unstable 7/31/2024
    eza
    fastfetch # like neofetch
    ffmpeg
    ffmpegthumbnailer
    file
    firefox
    freefilesync
    fzf
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
    pywal
    ripgrep
    rpi-imager
    rtl-sdr
    rtl_433
    sqlite-interactive
    unzip
    virt-manager
    virt-viewer
    vscodium
    wavemon
    wget
    xfce.thunar
    xfce.thunar-volman
    xfce.tumbler
    xfce.xfconf
    yarn
    yazi
    zoxide # cd replacement, with cdi
  ];
  
  home.file = {
    ".config/kitty/kitty.conf".source = ./.config/kitty/kitty.conf;
    ".zprofile".source = ./.zprofile;
    ".zshrc".source = ./.zshrc;
    "./.local/share/applications" = {
      source = ./.local/share/applications;
      recursive = true;
    };
    "./.local/bin" = {
      source = ./.local/bin;
      recursive = true;
    };
  };

  imports = [
    ./hyprland.nix
    # ./sway.nix
  ];

  gtk = {
    enable = true;
    theme = {
      package = pkgs.andromeda-gtk-theme;
      name = "Andromeda";
    };
    iconTheme = {
      package = pkgs.beauty-line-icon-theme;
      name = "BeautyLine";
    };
  };

  home.stateVersion = "24.05";

}
