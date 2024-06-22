{ config, pkgs, ... }:

{
  home.username = "doppler";
  home.homeDirectory = "/home/doppler";

  home.packages = with pkgs; [
    alacritty
    bitwarden
    # blender
    brave
    btop
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
    # slack
    sqlite-interactive
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

    wlroots
    pulseaudioFull
    pavucontrol
    gnome.nautilus
    hicolor-icon-theme
  ];
  
  home.file = {
    ".config/alacritty/alacritty.toml".text = builtins.readFile ./config/alacritty/alacritty.toml;
  };
    home.file = {
    "/bin/start-ecowitt.sh".text = builtins.readFile ./start-ecowitt.sh;
  };

  wayland.windowManager.sway = {
    enable = true;
    config = rec {
      modifier = "Mod4";
      # Use kitty as default terminal
      terminal = "kitty"; 
      startup = [
        # Launch Firefox on start
        {command = "firefox";}
      ];
    };
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
