{ config, lib, pkgs, security, ... }:
{
  security.sudo.wheelNeedsPassword = false;

  environment.systemPackages = with pkgs; [
    bun
    git
    tmux
    vim
  ];

  networking.networkmanager.enable = true;
  systemd.services.NetworkManager-wait-online.enable = false;

  environment.variables = { EDITOR = "vim"; };

  services.openssh.enable = true;

  nixpkgs.config.allowUnfree = true;

}

