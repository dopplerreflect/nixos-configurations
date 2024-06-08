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
    bun
    # deno
    # discord
    easyeffects
    # exiftool
    ffmpeg
    file
    firefox
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
    realvnc-vnc-viewer
    ripgrep
    rpi-imager
    # slack
    tmux
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
  ];
  
  home.file = {
    ".config/alacritty/alacritty.toml".text = builtins.readFile ./config/alacritty/alacritty.toml;
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
      picture-uri = "file:///home/doppler/flake/new3-2023-08-22T23_41_32.375Z.png";
      picture-uri-dark = "file:///home/doppler/flake/new3-2023-08-22T23_41_32.375Z.png";
      picture-options = "zoom";
    };
  };
  home.stateVersion = "24.05";

}
