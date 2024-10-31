{ config, pkgs, lib, ... }:

{
  home = {
    username = "doppler";
    homeDirectory = "/home/doppler";
    packages = with pkgs; [
      brave
      fzf
      kitty
      nautilus
      pulseaudioFull
      vscodium
      xfce.thunar
      xfce.thunar-volman
      xfce.tumbler
      xfce.xfconf
      yazi
    ];
    file = {
      ".config/kitty/kitty.conf".source = ../thinkpad/.config/kitty/kitty.conf;
      "./.local/bin" = {
        source = ./.local/bin;
        recursive = true;
      };
    };
    stateVersion = "24.11";
  };

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
  };
}
