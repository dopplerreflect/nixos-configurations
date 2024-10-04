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
    # extraHosts = "192.168.12.1 pi\n192.168.12.11 ecowitt ecowitt.local GW2000x\n192.168.122.173 nixos-qemu";
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
    displayManager = {
      defaultSession = "hyprland";
      sessionPackages = [ pkgs.hyprland ];
      autoLogin = {
        enable = true;
        user = "doppler";
      };
      # preStart = ''
      #   # Enable full RGB in HDMI driver
      #   # https://www.onetransistor.eu/2021/08/hdmi-picture-quantization-range-linux.html
      #   ${pkgs.libdrm}/bin/proptest -M i915 -D /dev/dri/card1 107 connector 103 1
      # '';
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
      # https://github.com/NixOS/nixpkgs/issues/328909 failing to build as of 2024-08-07
      # linuxKernel.packages.linux_zen.ddcci-driver # for controlling brightness of external monitor. 
    ];
    loginShellInit = ''
      [[ "$(tty)" == /dev/tty1 ]] && dbus-run-session hyprland
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

  virtualisation.libvirtd.enable = true;
  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };

  programs = {
    dconf.enable = true;
  };

  users.mutableUsers = false;
  users.users.doppler = {
    isNormalUser = true;
    hashedPassword = "$y$j9T$L4WXXG1W0rCNHzFrg8Q3D0$l7NOkrjD5B/VKUrHAjmfile5hDECM1yr6SJno71/xg1";
    description = "doppler";
    extraGroups = [ "networkmanager" "wheel" "libvirtd" "docker" "plugdev" ];
    shell = pkgs.zsh;
  };

  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
    # corefonts
    dejavu_fonts
    font-awesome
    # inconsolata
    # powerline-fonts
    # source-code-pro
    # source-sans-pro
    # source-serif-pro
    # terminus_font
  ];

  nixpkgs.config.permittedInsecurePackages = [ "googleearth-pro-7.3.6.9796" ];

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes";
  };

  system.stateVersion = "22.05";
}
