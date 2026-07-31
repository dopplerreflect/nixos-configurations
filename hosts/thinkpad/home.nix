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
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    firefox = {
      enable = true;
      package = pkgs.firefox;
      configPath = "${config.xdg.configHome}/mozilla/firefox";
    };
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
    cursorTheme = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
    };
  };
}
