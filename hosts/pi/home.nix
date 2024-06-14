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

  home.file = {
    "start-ecowitt.sh".text = builtins.readFile ./start-ecowitt.sh;
  };

  home.stateVersion = "24.05";
}

