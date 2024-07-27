{ config, pkgs, lib, ... }:

{
  home.username = "doppler";
  home.homeDirectory = "/home/doppler";

  home.packages = with pkgs; [
    adwaita-qt
    # ags # this is in nix profile instead due to broken upstream build
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
    kitty
    libnotify
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
    xdg-desktop-portal-hyprland
    yarn
    yazi
    zstd
  ];
  
  home.file = {
    ".config/swayidle/config".source = ./.config/swayidle/config;
    ".config/i3status-rust/config.toml".source = ./.config/i3status-rust/config.toml;
    ".config/mako/config".source = ./.config/mako/config;
  };

  programs = {
    alacritty = {
      enable = true;
      settings = {
        keyboard.bindings = [
          {
            key = "F";
            mods = "Command|Control";
            action = "ToggleFullScreen";
          }
        ];
        font.size = 16;
        window.opacity = 0.8;
        window.padding.x = 3;
        window.padding.y = 3;
      };
    };
  };

  wayland.windowManager = {
    sway = {
      enable = true;
      config = null;
      checkConfig = false;
      systemd.xdgAutostart = true;
      wrapperFeatures.gtk = true;
      extraConfig = lib.fileContents ./.config/sway/config;
    };
    hyprland = {
      enable = true;
      extraConfig = lib.fileContents ./.config/hypr/hyprland.conf;
    };
  };
 
  home.shellAliases = {
    ssh = "kitten ssh";
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
    iconTheme = {
      package = pkgs.gnome.adwaita-icon-theme;
      name = "Adwaita";
    };
  };

  home.stateVersion = "24.05";

}
