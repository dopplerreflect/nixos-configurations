{ config, lib, pkgs, security, ... }:
{
  security.sudo.wheelNeedsPassword = false;

  environment.systemPackages = with pkgs; [
    git
    tmux
    vim
  ];

  networking.networkmanager.enable = true;

  environment.variables = { EDITOR = "vim"; };

  services.openssh.enable = true;
}

