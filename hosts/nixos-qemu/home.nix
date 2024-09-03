{ config, pkgs, lib, ... }:

{
  home.username = "doppler";
  home.homeDirectory = "/home/doppler";

  home.packages = with pkgs; [
    brave
    bat
    eza
    fastfetch # like neofetch
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
    zoxide # cd replacement, with cdi
  ];
  
  home.file = {
    ".config/kitty/kitty.conf".source = ../thinkpad/.config/kitty/kitty.conf;
    ".zshrc".source = ../thinkpad/.zshrc;
    "./.local/bin" = {
      source = ./.local/bin;
      recursive = true;
    };
  };

  imports = [
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
  };

  home.stateVersion = "24.11";

}
