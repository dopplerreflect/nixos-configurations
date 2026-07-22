{ pkgs, config, ... }:
{
  home = {
    username = "doppler";
    homeDirectory = "/home/doppler";
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
      # nativeMessagingHosts = [ pkgs.firefoxpwa ];
      configPath = "${config.xdg.configHome}/mozilla/firefox";
    };
    # zen-browser.enable = true;
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
    gtk4.theme = config.gtk.theme;
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
