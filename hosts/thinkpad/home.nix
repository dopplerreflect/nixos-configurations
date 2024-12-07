{pkgs, ...}: {
  home = {
    username = "doppler";
    homeDirectory = "/home/doppler";
    packages = with pkgs; [
      # alejandra # nix file formatter. use vscode plugin, too.
      authenticator
      # ags # this is in nix profile instead due to broken upstream build
      bitwarden
      brave
      btop
      gh
      # gqrx
      helix # text editor added 2024-11-18
      homebank # finance app
      imv
      mpv
      nautilus
      nextcloud-client
      nodejs
      ollama
      pavucontrol
      pnpm
      unzip
      virt-manager
      virt-viewer
      vscodium
      wavemon
      xfce.thunar
      xfce.thunar-volman
      xfce.tumbler
      xfce.xfconf
      yarn
      yazi
    ];
    file = {
      "./.local/share/applications" = {
        source = ./.local/share/applications;
        recursive = true;
      };
      "./.local/bin" = {
        source = ./.local/bin;
        recursive = true;
      };
    };
    stateVersion = "24.05";
  };

  imports = [
    ./hyprland
    ../../programs/kitty
    ../../programs/nh
    ../../programs/nushell
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
      package = pkgs.nixos-24-11.bibata-cursors;
      name = "Bibata-Modern-Ice";
    };
  };
}
