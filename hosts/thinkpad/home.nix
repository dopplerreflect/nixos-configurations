{pkgs, ...}: {
  home = {
    username = "doppler";
    homeDirectory = "/home/doppler";
    packages = with pkgs; [
      alejandra # nix file formatter. use vscode plugin, too.
      authenticator
      # ags # this is in nix profile instead due to broken upstream build
      bitwarden
      brave
      btop
      gh
      # gqrx
      helix # text editor added 2024-11-18
      imv
      kitty
      mpv
      nautilus
      nextcloud-client
      nodejs
      pavucontrol
      pnpm
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
    stateVersion = "24.05";
  };

  imports = [
    ./hyprland
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
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
    };
  };

  systemd.user.services = {
    cycle-desktop-background = {
      Unit = {
        Description = "Cycle Desktop Backgrounds";
        PartOf = ["graphical-session.target"];
        After = ["graphical-session.target"];
        ConditionEnvironment = "WAYLAND_DISPLAY";
      };
      Service = {
        Type = "simple";
        ExecStart = "/home/doppler/.local/bin/cycle-desktop-backgrounds.ts";
        Restart = "on-failure";
      };
      Install = {
        WantedBy = ["graphical-session.target"];
      };
    };
  };
}
