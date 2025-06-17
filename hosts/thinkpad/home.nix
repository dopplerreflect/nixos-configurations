{ pkgs, ... }:
{
  home = {
    username = "doppler";
    homeDirectory = "/home/doppler";
    packages = with pkgs; [
      authenticator
      bitwarden
      brave
      btop
      gh
      googleearth-pro
      # gqrx
      file
      firefox
      # freefilesync
      # ghostty
      gimp
      # helix
      # homebank
      imv
      # inkscape
      jujutsu
      librsvg
      mpv
      nautilus
      nextcloud-client
      # nixos-stable.nixd
      nixd
      nixfmt-rfc-style
      nodejs
      ollama
      pavucontrol
      pnpm
      prettier
      unzip
      virt-manager
      virt-viewer
      vscodium
      # wavemon
      # xfce.thunar
      # xfce.thunar-volman
      # xfce.tumbler
      # xfce.xfconf
      yarn
      yazi
    ];
    file = {
      "./.local/share/applications" = {
        source = ./.local/share/applications;
        recursive = true;
      };
    };
    stateVersion = "24.05";
  };

  programs = {
    firefox = {
      enable = true;
      package = pkgs.firefox;
      nativeMessagingHosts = [ pkgs.firefoxpwa ];
    };
    helix = {
      enable = true;
      extraPackages = with pkgs; [
        svelte-language-server
        typescript-language-server
      ];
    };
    tmux = {
      enable = true;
      plugins = with pkgs; [
        tmuxPlugins.tokyo-night-tmux
      ];
    };
  };

  imports = [
    ../../wm/hyprland
    ../../programs/kitty
    ../../programs/nh
    # ../../programs/nushell
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
    cursorTheme = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
    };
  };
}
