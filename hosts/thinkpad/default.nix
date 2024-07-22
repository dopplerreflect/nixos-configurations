{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_zen;
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    loader.efi.efiSysMountPoint = "/boot/efi";
    binfmt.emulatedSystems = [ "aarch64-linux" ];
    blacklistedKernelModules = [ "i2c_i801" ];
    kernel = {
      sysctl = {
        "net.ipv6.conf.wlp0s20f3.hop_limit" = 66;
        "net.ipv4.ip_default_ttl" = 66;
      };
    };
  };

  networking = {
    hostName = "thinkpad";
    extraHosts = "192.168.12.1 pi\n192.168.12.11 ecowitt ecowitt.local GW2000x";
    nameservers = [ "8.8.8.8" ];
    firewall.enable = false;
  };

  services = {
    udisks2 = {
      enable = true;
      mountOnMedia = true;
    };
    gvfs.enable = true;
    gnome.gnome-keyring.enable = true;
    displayManager.sessionPackages = [ pkgs.sway ];
    xserver = {
      enable = true;
      xkb = {
        layout = "us";
        variant = "dvorak";
        options = "ctrl:nocaps";
      };
      excludePackages = with pkgs; [ xterm ];
    };
  };


  environment = {
    loginShellInit = ''
      [[ "$(tty)" == /dev/tty1 ]] && dbus-run-session sway
    '';
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

  sound.enable = true;
  hardware.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  hardware.rtl-sdr.enable = true;

  virtualisation.libvirtd.enable = true;
  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };

  programs.dconf.enable = true;

  users.users.doppler = {
    isNormalUser = true;
    description = "doppler";
    extraGroups = [ "networkmanager" "wheel" "libvirtd" "docker" "plugdev" ];
    shell = pkgs.zsh;
  };

  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
    corefonts
    terminus_font
    inconsolata
    dejavu_fonts
    font-awesome
    source-code-pro
    source-sans-pro
    source-serif-pro
  ];

  nixpkgs.config.permittedInsecurePackages = [ "googleearth-pro-7.3.4.8248" ];

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes";
  };

  system.stateVersion = "22.05";
}
