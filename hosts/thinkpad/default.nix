{ pkgs, lib, inputs, ... }:
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
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
    devmon.enable = true;
    displayManager = {
      dms-greeter = {
        enable = true;
        compositor = {
          name = "hyprland";
          customConfig = ''
            input {
              kb_layout = us
              kb_variant = dvorak
            }
          '';
          };
        configHome = "/home/doppler";
      };
    };
    fwupd.enable = true;
    gnome.gnome-keyring.enable = true;
    gvfs.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    power-profiles-daemon.enable = true;
    printing = {
      enable = true;
      listenAddresses = [ "*:631" ];
      allowFrom = [ "all" ];
      browsing = true;
      defaultShared = true;
      openFirewall = true;
      drivers = with pkgs; [
        cups-filters
        cups-browsed
        hplip
      ];
    };
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
    pathsToLink = [ "/share/zsh" "/share/applications" "/share/xdg-desktop-portal" ];
    sessionVariables = {
      ELECTRON_OZONE_PLATFORM_HINT = "wayland";
      PATH = [ "$HOME/.local/bin" "$HOME/.yarn/bin" ];
    };
  };
  imports = [
    inputs.dms.nixosModules.dank-material-shell
    inputs.dms.nixosModules.greeter
    ./environment.systemPackages.nix
  ];

  security = {
    polkit.enable = true;
    rtkit.enable = true;
  };

  hardware = {
    rtl-sdr.enable = true;
    graphics = {
      enable = true;
      extraPackages = with pkgs;
        [ intel-media-driver vpl-gpu-rt ];
    };
  };

  virtualisation = {
    libvirtd.enable = true;
  };

  programs = {
    dconf.enable = true;
    dank-material-shell= {
      enable = true;
      systemd = {
        enable = true;
        restartIfChanged = true;
      };
      # greeter = {
      #   enable = true;
      #   compositor = {
      #     name = "hyprland";
      #     customConfig = ''
      #       input {
      #         kb_layout = us
      #         kb_variant = dvorak
      #       }
      #     '';
      #     };
      #   configHome = "/home/doppler";
      # };
    };
    hyprland = {
      enable = true;
      withUWSM = true;
    };
    kdeconnect = {
      enable = true;
      package = pkgs.kdePackages.kdeconnect-kde;
    };
  };

  users = {
    mutableUsers = false;
    users.doppler = {
      isNormalUser = true;
      hashedPassword = "$y$j9T$L4WXXG1W0rCNHzFrg8Q3D0$l7NOkrjD5B/VKUrHAjmfile5hDECM1yr6SJno71/xg1";
      description = "doppler";
      extraGroups = [
        "input"
        "libvirtd"
        "networkmanager"
        "plugdev"
        "render"
        "video"
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

  nixpkgs.config.allowInsecurePredicate = pkg: builtins.elem (lib.getName pkg) [ "googleearth-pro" ];

  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = "nix-command flakes";
    };
  };

  system.stateVersion = "22.05";
}
