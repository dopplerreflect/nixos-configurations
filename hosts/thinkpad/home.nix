{ pkgs, ...}:

{
  home.username = "doppler";
  home.homeDirectory = "/home/doppler";

  home.packages = with pkgs; [
    # ags # this is in nix profile instead due to broken upstream build
    bc
    bitwarden
    brave
    btop
    dconf-editor
    # easyeffects # php requirement was failing test on nixos-unstable 7/31/2024
    ffmpeg
    ffmpegthumbnailer
    file
    firefox
    freefilesync
    fzf
    gimp
    gnome-characters
    gnome-tweaks
    googleearth-pro
    # gqrx
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
    nextcloud-client
    nmap
    nodejs
    pavucontrol
    pnpm
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
  ];
  
  home.file = {
    ".config/kitty/kitty.conf".source = ./.config/kitty/kitty.conf;
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
    ./hyprland
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
