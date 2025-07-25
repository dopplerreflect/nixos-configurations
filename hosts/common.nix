{
  pkgs,
  ...
}:
{
  imports = [
    ../programs/git.nix
    ../programs/neovim.nix
    ../programs/zsh
    # ../programs/fish
  ];

  time.timeZone = "America/Chicago";
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    earlySetup = true;
    font = "${pkgs.powerline-fonts}/share/consolefonts/ter-powerline-v28b.psf.gz";
    packages = with pkgs; [ powerline-fonts ];
    keyMap = "dvorak";
  };

  security.sudo.wheelNeedsPassword = false;
  networking = {
    networkmanager.enable = true;
    extraHosts = ''
      192.168.12.1 pi
      192.168.12.10 thinkpad thinkpad.local
      192.168.12.11 ecowitt ecowitt.local GW2000x
    '';
  };

  systemd.services.NetworkManager-wait-online.enable = false;
  services.openssh.enable = true;

  nixpkgs.config.allowUnfree = true;
}
