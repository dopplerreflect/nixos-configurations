{ config, pkgs, ... }:

{
  home.username = "doppler";
  home.homeDirectory = "/home/doppler";

  home.packages = with pkgs; [
    btop
  ];

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

  home.stateVersion = "23.11";
}

