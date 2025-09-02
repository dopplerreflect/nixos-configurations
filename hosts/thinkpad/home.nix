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
      bun
      gh
      # googleearth-pro
      # gqrx
      file
      firefoxpwa
      # freefilesync
      # ghostty
      gimp3
      # helix
      # homebank
      imv
      inkscape
      krita
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
      ripgrep
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
    zen-browser.enable = true;
  };

  imports = [
    ../../wm/hyprland
    ../../programs/fzf.nix
    ../../programs/helix.nix
    ../../programs/jujutsu.nix
    ../../programs/kitty
    ../../programs/nh.nix
    ../../programs/tmux.nix
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
