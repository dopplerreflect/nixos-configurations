{ config, pkgs, lib, ... }:

{
  home.username = "doppler";
  home.homeDirectory = "/home/doppler";

  home.packages = with pkgs; [
    alacritty
    bitwarden
    # blender
    brave
    btop
    bc
    chromedriver
    # bun # moved to system
    # deno
    # discord
    easyeffects
    # exiftool
    fastfetch # like neofetch
    ffmpeg
    file
    firefox
    freefilesync
    gqrx
    gimp
    git
    gnome.dconf-editor
    gnome3.gnome-tweaks
    google-chrome
    googleearth-pro
    heroku
    imagemagick
    imv
    inkscape
    miller # miller text parser thing https://miller.readthedocs.io/en/latest/
    mpv
    nmap
    nodejs
    # obs-studio
    python3
    realvnc-vnc-viewer
    ripgrep
    rpi-imager
    rtl-sdr
    rtl_433
    # slack
    sqlite-interactive
    # tracker
    # tracker-miners
    unzip
    vim
    virt-manager
    virt-viewer
    vscode
    yarn
    # youtube-dl
    wget
    # zoom-us
    zstd

    # sway
    i3status-rust
    wlroots
    pulseaudioFull
    pavucontrol
    gnome.nautilus
    hicolor-icon-theme
    dmenu
    wofi
    slurp
    swaylock
    swayidle
    swaybg
    wl-clipboard
    mako
    nwg-launchers
    nwg-bar
    sway-contrib.grimshot
  ];
  
  home.file = {
    ".config/alacritty/alacritty.toml".text = builtins.readFile ./config/alacritty/alacritty.toml;
  };
  home.file = {
    "/bin/start-ecowitt.sh".text = builtins.readFile ./start-ecowitt.sh;
  };

  wayland.windowManager.sway = {
    enable = true;
    # package = null;
    config = null;
    checkConfig = false;
    systemd.xdgAutostart = true;
    wrapperFeatures.gtk = true;
    # commented out while still fucking with it

    # all the rest of this was proving to be a pain in the ass
    extraConfig = lib.fileContents ../common/.config/sway/config;
    #config = rec {
    #  modifier = "Mod4";
    #  # Use kitty as default terminal
    #  terminal = "alacritty"; 
    #  startup = [
    #    # Launch Firefox on start
    #    {command = "brave";}
    #  ];
    #  input = {
    #    "type:keyboard" = {
    #      xkb_layout = "us";
    #      xkb_variant = "dvorak";
    #      xkb_options = "caps:ctrl_modifier";
    #    };
    #    "type:touchpad" = {
    #      dwt = "enabled";
    #      tap = "enabled";
    #      natural_scroll = "enabled";
    #      click_method = "clickfinger";
    #    };
    #  };
    #  output = {
    #    "DP-1" = {
    #      resolution = "1920x1080";
    #      position = "0,0";
    #    };
    #    "eDP-1" = {
    #      resolution = "1920x1080";
    #      position = "0,1080";
    #    };
    #  };
    #  assigns = {
    #    "1" = [{ class = "^Brave-browser$"; }];
    #    "2" = [{ class = "^Code$"; }];
    #  };
    #  bars = [
    #    {
    #      id = "bar-test";
    #      statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs";
    #      position = "bottom";
    #      hiddenState = "show";
    #      fonts = {
    #        names = [ "Font Awesome 6 Pro" "DejaVu Sans Mono" ];
    #        size = 14.0;
    #      };
    #    }
    #  ];
    #};
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
  home.stateVersion = "24.05";

}
