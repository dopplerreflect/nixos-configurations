{ config, lib, pkgs, security, ... }:
{
  security.sudo.wheelNeedsPassword = false;

  imports = [
    ../programs/git.nix
    ../programs/neovim.nix
    ../programs/zsh.nix
  ];

  environment.systemPackages = with pkgs; [
    bun
    # git
    tmux
  ];

  networking.networkmanager.enable = true;
  systemd.services.NetworkManager-wait-online.enable = false;

  services.openssh.enable = true;

  nixpkgs.config.allowUnfree = true;

}

