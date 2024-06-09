{ config, pkgs, ... }:

{
  home.username = "justin";
  home.homeDirectory = "/home/justin";

  home.packages = with pkgs; [
    btop
  ];

  # programs.git = {
  #   enable = true;
  #   userName = "David Rose";
  #   userEmail = "doppler@gmail.com";
  #   aliases = {
  #     co = "checkout";
  #     st = "status";
  #     br = "branch";
  #     ci = "commit";
  #   };
  # };

  home.stateVersion = "24.05";
}

