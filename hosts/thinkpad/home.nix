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
    dmenu
    easyeffects
    fastfetch # like neofetch
    ffmpeg
    file
    firefox
    freefilesync
    gimp
    git
    gnome.dconf-editor
    gnome.nautilus
    gnome3.gnome-tweaks
    googleearth-pro
    gqrx
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
    onagre # launcher
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
    unzip
    vim
    virt-manager
    virt-viewer
    vscode
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
  home.file = {
    "/bin/start-ecowitt.sh".text = builtins.readFile ./start-ecowitt.sh;
  };

  wayland.windowManager.sway = {
    enable = true;
    config = null;
    checkConfig = false;
    systemd.xdgAutostart = true;
    wrapperFeatures.gtk = true;
    extraConfig = lib.fileContents ./config/sway/config;
  };

  programs.git = {
    enable = true;
    userName = "David Rose";
    userEmail = "doppler@gmail.com";
    aliases = {
      co = "checkout";
      st = "status";
      br = "branch";
      ci = "commit";
    };
  };
  
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    # shellAliases = {
    #   code = "code --enable-features=UseOzonePlatform --ozone-platform=wayland";
    # };
    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
      theme = "agnoster";
    };
    zplug = {
      enable = true;
      plugins = [
        { name = "spwhitt/nix-zsh-completions"; }
      ];
    };
  };

  dconf.settings = {
    "org/gnome/desktop/background" = {
      picture-uri = ''${./bg.png}'';
      picture-uri-dark = ''${./bg.png}'';
      picture-options = "zoom";
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
