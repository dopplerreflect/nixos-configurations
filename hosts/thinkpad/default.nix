{ pkgs, ... }:
{
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      efi.efiSysMountPoint = "/boot/efi";
    };
    kernel = {
      sysctl = {
        "net.ipv6.conf.wifi.hop_limit" = 66;
        "net.ipv4.ip_default_ttl" = 66;
      };
    };
    kernelPackages = pkgs.linuxKernel.packages.linux_zen;
    # kernelPackages = pkgs.linuxPackages_cachyos;
    binfmt.emulatedSystems = [ "aarch64-linux" ];
    # suppress "i801_smbus 0000:00:1f.4: SMBus is busy, can't use it!"
    blacklistedKernelModules = [ "i2c_i801" ];
  };

  networking = {
    hostName = "thinkpad";
    nameservers = [ "9.9.9.9" ];
    firewall.enable = false;
  };

  systemd.network.links = {
    "10-internet" = {
      matchConfig.PermanentMACAddress = "a0:ce:c8:de:a0:43";
      linkConfig.Name = "eth0";
    };
    "11-internet" = {
      matchConfig.PermanentMACAddress = "54:05:db:a6:f2:9c";
      linkConfig.Name = "eth1";
    };
    "12-internet" = {
      matchConfig.PermanentMACAddress = "3c:9c:0f:fc:0c:51";
      linkConfig.Name = "wifi";
    };
  };

  services = {
    # kmscon = {
    #   enable = true;
    #   extraConfig = ''
    #     font-size=18
    #     xkb-layout=us
    #     xkb-variant=dvorak
    #     xkb-options=ctrl:nocaps
    #   '';
    # };
    desktopManager.cosmic.enable = true;
    devmon.enable = true;
    displayManager = {
      # autoLogin = {
      #   enable = true;
      #   user = "doppler";
      # };
      cosmic-greeter.enable = true;
      defaultSession = "hyprland";
      sessionPackages = [
        pkgs.hyprland
        pkgs.cosmic-session
      ];
    };
    fwupd.enable = true;
    gnome.gnome-keyring.enable = true;
    gvfs.enable = true;
    nginx = {
      enable = true;
      virtualHosts."thinkpad" = {
        root = "/var/www";
      };
    };
    # ollama = {
    #   enable = true;
    # };
    # open-webui = {
    #   enable = true;
    # };
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    power-profiles-daemon.enable = true;
    tailscale.enable = true;
    udisks2 = {
      enable = true;
      mountOnMedia = true;
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
    pathsToLink = [ "/share/zsh" ];
    sessionVariables = {
      ELECTRON_OZONE_PLATFORM_HINT = "wayland";
      PATH = [ "$HOME/.local/bin" "$HOME/.yarn/bin" ];
    };
  };

  security = {
    pam.services.cosmic-greeter = {
      enableGnomeKeyring = true;
      kwallet.enable = true;
    };
    polkit.enable = true;
    rtkit.enable = true;
  };

  hardware = {
    rtl-sdr.enable = true;
  };

  virtualisation = {
    docker = {
      enable = true;
      rootless = {
        enable = true;
        setSocketVariable = true;
      };
    };
    libvirtd.enable = true;
  };

  programs = {
    dconf.enable = true;
  };

  users = {
    mutableUsers = false;
    users.doppler = {
      isNormalUser = true;
      hashedPassword = "$y$j9T$L4WXXG1W0rCNHzFrg8Q3D0$l7NOkrjD5B/VKUrHAjmfile5hDECM1yr6SJno71/xg1";
      description = "doppler";
      extraGroups = [
        "docker"
        "input"
        "libvirtd"
        "networkmanager"
        "nginx"
        "plugdev"
        "wheel"
      ];
      shell = pkgs.zsh;
      ignoreShellProgramCheck = true;
    };
  };

  fonts.packages = with pkgs; [
    dejavu_fonts
    font-awesome
    nerd-fonts.fira-code
  ];

  nixpkgs.config.permittedInsecurePackages = [ "googleearth-pro-7.3.6.10201" ];

  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = "nix-command flakes";
    };
  };

  system.stateVersion = "22.05";
}
