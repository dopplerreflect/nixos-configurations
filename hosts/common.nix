{ config, lib, pkgs, security, ... }:

{
  imports = [
    ../programs/git.nix
    ../programs/neovim.nix
    ../programs/zsh.nix
  ];

  time.timeZone = "America/Chicago";
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    earlySetup = true;
    font = "${pkgs.powerline-fonts}/share/consolefonts/ter-powerline-v28b.psf.gz";
    packages = with pkgs; [ terminus_font ];
    keyMap = "dvorak";
  };

  environment.systemPackages = with pkgs; [
    bun
    tmux
  ];

  security.sudo.wheelNeedsPassword = false;
  networking.networkmanager.enable = true;
  systemd.services.NetworkManager-wait-online.enable = false;
  services.openssh.enable = true;

  nixpkgs.config.allowUnfree = true;

}

