{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      efi.efiSysMountPoint = "/boot/efi";
      timeout = 0;
    };
    kernel = {
      sysctl = {
        "net.ipv6.conf.wifi.hop_limit" = 66;
        "net.ipv4.ip_default_ttl" = 66;
      };
    };
    kernelPackages = pkgs.linuxPackages_zen;
    binfmt.emulatedSystems = [ "aarch64-linux" ];
    plymouth = {
      enable = true;
      theme = "rings";
      themePackages = with pkgs; [
        (adi1090x-plymouth-themes.override {
          selected_themes = [ "rings" ];
        })
      ];
    };
    consoleLogLevel = 0;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "loglevel=3"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
    ];
    # suppress "i801_smbus 0000:00:1f.4: SMBus is busy, can't use it!"
    blacklistedKernelModules = [ "i2c_i801" ];
  };

  networking = {
    hostName = "thinkpad";
    nameservers = [ "8.8.8.8" ];
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
    displayManager = {
      defaultSession = "hyprland";
      sessionPackages = [ pkgs.hyprland ];
      autoLogin = {
        enable = true;
        user = "doppler";
      };
    };
    fwupd.enable = true;
    # 2024-11-08 do we need this?
    # yep, for Authenicator, apparently
    gnome.gnome-keyring.enable = true;
    gvfs.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
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
    sessionVariables = rec {
      GTK_THEME = "Adwaita:dark";
      PATH = [ "$HOME/.local/bin" ];
    };
  };

  security = {
    rtkit.enable = true;
    # 2024-11-08 to keep brave from asking for user password
    pam.services.lightdm.enableKwallet = true;
    polkit.enable = true;
  };

  hardware = {
    # pulseaudio.enable = false;
    rtl-sdr.enable = true;
  };

  virtualisation = {
    libvirtd.enable = true;
    docker = {
      enable = true;
      rootless = {
        enable = true;
        setSocketVariable = true;
      };
    };
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
      extraGroups = [ "networkmanager" "wheel" "libvirtd" "docker" "plugdev" ];
      shell = pkgs.zsh;
    };
  };

  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
    dejavu_fonts
    font-awesome
  ];

  nixpkgs.config.permittedInsecurePackages = [ "googleearth-pro-7.3.6.9796" ];

  nix = {
    package = pkgs.nixVersions.stable;
    extraOptions = "experimental-features = nix-command flakes";
  };

  system.stateVersion = "22.05";
}
