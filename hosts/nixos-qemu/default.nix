{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos-qemu";
  networking.networkmanager.enable = true;

  time.timeZone = "America/Chicago";

  i18n.defaultLocale = "en_US.UTF-8";

  programs.dconf.enable = true;

  users.users.doppler = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    packages = with pkgs; [
    ];
  };

  services = {
    gvfs.enable = true;
    gnome.gnome-keyring.enable = true;
    displayManager = {
      defaultSession = "hyprland";
      sessionPackages = [ pkgs.hyprland ];
      autoLogin = {
        enable = true;
        user = "doppler";
      };
    };
    xserver = {
      enable = true;
      autorun = false;
      xkb = {
        layout = "us";
        variant = "dvorak";
        options = "ctrl:nocaps";
      };
      excludePackages = with pkgs; [ xterm ];
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
    pam.services.swaylock.text = ''auth include login'';
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
    package = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes";
  };

  system.stateVersion = "24.11"; # Did you read the comment?

}
