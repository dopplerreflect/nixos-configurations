{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    hostName = "nixos-qemu";
    networkmanager.enable = true;
    firewall.allowedTCPPorts = [ 22 80 ];
  };

  programs.dconf.enable = true;

  users.users.doppler = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    shell = pkgs.zsh;
    packages = with pkgs; [
    ];
  };

  environment.etc."nextcloud-admin-pass".text = "Para-Dongle-1";
  
  services = {
    nextcloud = {
      enable = true;
      package = pkgs.nextcloud29;
      hostName = "nixos-qemu";
      config.adminpassFile = "/etc/nextcloud-admin-pass";
    };
    nginx.virtualHosts."localhost".listen = [ { addr = "0.0.0.0"; } ];
    gvfs.enable = true;
    gnome.gnome-keyring.enable = true;
    displayManager = {
      defaultSession = "xfce";
      # sessionPackages = [ pkgs.hyprland ];  
      autoLogin = {
        enable = true;
        user = "doppler";
      };
    };
    xserver = {
      enable = true;
      desktopManager.xfce.enable = true;
      xkb = {
        layout = "us";
        variant = "dvorak";
        options = "ctrl:nocaps";
      };
      excludePackages = with pkgs; [ xterm ];
    };
    picom = {
      enable = true;
      fade = true;
      inactiveOpacity = 0.8;
      shadow = true;
      fadeDelta = 4;
    };
  };

  environment = {
    systemPackages = with pkgs; [
    ];
    variables = {
      UV_USE_IO_URING = 0; # workaround for https://github.com/nodejs/node/issues/53051
    };
    sessionVariables = rec {
      GTK_THEME = "Adwaita:dark";
      PATH = [ "$HOME/.local/bin" ];
    };
  };

  security = {
    rtkit.enable = true;
    polkit.enable = true;
  };

  # sound.enable = true;
  hardware.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  hardware.rtl-sdr.enable = true;

  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
    corefonts
    dejavu_fonts
    terminus_font
  ];

  nix = {
    package = pkgs.nixVersions.stable;
    extraOptions = "experimental-features = nix-command flakes";
  };

  system.stateVersion = "24.11"; # Did you read the comment?

}
