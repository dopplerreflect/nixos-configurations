{ config, pkgs, ... }:

{
  home.username = "doppler";
  home.homeDirectory = "/home/doppler";

  home.packages = with pkgs; [
    bat
    btop
    eza
  ];

  home.file = {
    "start-ecowitt.sh".text = builtins.readFile ./start-ecowitt.sh;
  };

  home.stateVersion = "24.05";
}

