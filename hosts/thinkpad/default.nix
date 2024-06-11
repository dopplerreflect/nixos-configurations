{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot = {
    kernelPackages = pkgs.linuxPackages_zen;
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    loader.efi.efiSysMountPoint = "/boot/efi";
    binfmt.emulatedSystems = [ "aarch64-linux" ];
  };

  networking = {
    hostName = "thinkpad"; # Define your hostname.
    networkmanager.enable = true;
    extraHosts = "10.42.0.1 wfbase\n192.168.12.1 pi";
    nameservers = [ "8.8.8.8" ];
    firewall.enable = false;
  };

  time.timeZone = "America/Chicago";
  i18n.defaultLocale = "en_US.utf8";
  console.keyMap = "dvorak";

  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    # layout = "us";
    # xkbVariant = "dvorak";
    # xkbOptions = "ctrl:nocaps";
    xkb = {
      layout = "us";
      variant = "dvorak";
      options = "ctrl:nocaps";
    };
  };
  services.gnome.gnome-browser-connector.enable = true;

  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  virtualisation.libvirtd.enable = true;
  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };

  programs.dconf.enable = true;
  programs.zsh.enable = true;

  users.users.doppler = {
    isNormalUser = true;
    description = "doppler";
    extraGroups = [ "networkmanager" "wheel" "libvirtd" "docker" ];
    shell = pkgs.zsh;
  };

  environment.systemPackages = with pkgs; [
    vim
  ];
  environment.variables = {
    EDITOR = "vi";
    UV_USE_IO_URING = 0; # workaround for https://github.com/nodejs/node/issues/53051
  };

  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
  ];

  system.stateVersion = "22.05"; # Did you read the comment?

  security.sudo.wheelNeedsPassword = false;
  nixpkgs.config.allowUnfree = true;

  services.sshd.enable = true;

  nixpkgs.config.permittedInsecurePackages = [ "googleearth-pro-7.3.4.8248" ];

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes";
  };

}
