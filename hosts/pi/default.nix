{
  config,
  pkgs,
  ...
}:
{
  boot = {
    kernelPackages = pkgs.linuxKernel.packages.linux_rpi4;
    initrd.availableKernelModules = [
      "xhci_pci"
      "usbhid"
      "usb_storage"
    ];
    initrd.systemd.tpm2.enable = false; # https://github.com/NixOS/nixos-hardware/issues/858
    blacklistedKernelModules = [ "rtl8xxxu" ];
    kernelModules = [ "88x2bu" ];
    extraModulePackages = [
      config.boot.kernelPackages.rtl88x2bu
    ];
    loader = {
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
    };
    kernel = {
      sysctl = {
        "net.ipv6.conf.extwifi.hop_limit" = 65;
        "net.ipv4.ip_default_ttl" = 65;
      };
    };
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
      options = [ "noatime" ];
    };
  };

  networking = {
    hostName = "pi";
    # extraHosts = "192.168.12.11 GW2000X ecowitt\n192.168.12.10 thinkpad";
    firewall = {
      enable = false;
    };
  };

  systemd.network.links = {
    "10-internet" = {
      matchConfig.PermanentMACAddress = "60:fb:00:62:b2:72";
      linkConfig.Name = "extwifi";
    };
    "11-internet" = {
      matchConfig.PermanentMACAddress = "dc:a6:32:bd:9b:4c";
      linkConfig.Name = "intwifi";
    };
  };

  nixpkgs.overlays = [
    (_: prev: {
      linux-wifi-hotspot = prev.linux-wifi-hotspot.overrideAttrs (_: {
        src = prev.fetchFromGitHub {
          owner = "dopplerreflect";
          repo = "linux-wifi-hotspot";
          rev = "bfe7ca6f4bab6e20e1a94197714b1938e4ac3337";
          hash = "sha256-y+3Pav72JJNgq/C1DoPFLl84SXy9+3nu7V5Qh4U/4Xc=";
        };
      });
    })
  ];

  services = {
    create_ap = {
      enable = true;
      settings = {
        CHANNEL = 3;
        ETC_HOSTS = 1;
        DHCP_HOSTS = "thinkpad GW2000X";
        DHCP_DNS = "192.168.12.1,9.9.9.9";
        INTERNET_IFACE = "extwifi";
        WIFI_IFACE = "intwifi";
        SSID = "pi";
        PASSPHRASE = "anewpass";
      };
    };
    nextcloud = {
      enable = true;
      package = pkgs.nextcloud31;
      hostName = "pi";
      config = {
        adminpassFile = "/etc/nextcloud-admin-pass";
        dbtype = "sqlite";
      };
    };
    nginx.virtualHosts."localhost".listen = [ { addr = "0.0.0.0"; } ];
    tailscale.enable = true;
  };

  environment = {
    pathsToLink = [ "/share/zsh" ];
    etc."nextcloud-admin-pass".text = "Para-Dongle-1";
    systemPackages = with pkgs; [
      bun
      linux-wifi-hotspot
      nodejs
      tmux
      wavemon
      yarn
    ];
  };

  imports = [
    ../../programs/nh
  ];

  users = {
    users.doppler = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "networkmanager"
      ];
      shell = pkgs.zsh;
      ignoreShellProgramCheck = true;
    };
  };

  systemd.services.ecowitt = {
    description = "Ecowitt Weather Thing";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    serviceConfig = {
      Type = "forking";
      User = "doppler";
      WorkingDirectory = "/home/doppler";
      ExecStart = "/run/current-system/sw/bin/sh /home/doppler/start-ecowitt.sh";
      ExecStop = "/run/current-system/sw/bin/tmux kill-session -t ecowitt";
    };
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  hardware = {
    bluetooth.enable = true;
    raspberry-pi."4".bluetooth.enable = true;
    enableRedistributableFirmware = true;
  };

  #  systemd.services.btattach = {
  #    before = [ "bluetooth.service" ];
  #    after = [ "dev-ttyAMA0.device" ];
  #    wantedBy = [ "multi-user.target" ];
  #    serviceConfig = {
  #      ExecStart = "${pkgs.bluez}/bin/btattach -B /dev/ttyAMA0 -P bcm -S 3000000";
  #    };
  #  };

  system.stateVersion = "23.11";
}
