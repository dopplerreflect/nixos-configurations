{ config, pkgs, lib, ... }:

{
  security.sudo.wheelNeedsPassword = false;

  imports = [
    ../common
    # ./bluetooth.nix
  ];

  boot = {
    kernelPackages = pkgs.linuxKernel.packages.linux_rpi4;
    initrd.availableKernelModules = [ "xhci_pci" "usbhid" "usb_storage" ];
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
        "net.ipv6.conf.wlp1s0u1u2.hop_limit" = 65;
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
    extraHosts = "192.168.12.11 GW2000X ecowitt\n192.168.12.10 thinkpad";
    firewall = {
      enable = false;
      # allowedTCPPorts = [ 22 80 3000 ];
      # extraCommands = "iptables -t nat -A PREROUTING -i wlan0 -p tcp --dport 80 -j REDIRECT --to-port 3000";
    };
  };

  nixpkgs.overlays = [ (final: prev: {
    linux-wifi-hotspot = prev.linux-wifi-hotspot.overrideAttrs (old: {
      src = prev.fetchFromGitHub {
        owner = "dopplerreflect";
        repo = "linux-wifi-hotspot";
        rev = "bfe7ca6f4bab6e20e1a94197714b1938e4ac3337";
        hash = "sha256-y+3Pav72JJNgq/C1DoPFLl84SXy9+3nu7V5Qh4U/4Xc=";
      };
    });
  }) ];

  services.create_ap = {
    enable = true;
    settings = {
      ETC_HOSTS=1;
      DHCP_HOSTS = "thinkpad GW2000X";
      DHCP_DNS = "192.168.12.1,8.8.8.8,8.8.4.4,1.1.1.1";
      INTERNET_IFACE = "wlp1s0u1u2";
      WIFI_IFACE = "wlan0";
      SSID = "pi";
      PASSPHRASE = "wifipass";
    };
  };

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    earlySetup = true;
    font = "${pkgs.terminus_font}/share/consolefonts/ter-124n.psf.gz";
    packages = with pkgs; [ terminus_font ];
    keyMap = "dvorak";
  };

  environment.systemPackages = with pkgs; [ 
    bun
    linux-wifi-hotspot
    nodejs
    yarn
  ];

  users = {
    mutableUsers = false;
    users.doppler = {
      isNormalUser = true;
      password = "bb";
      extraGroups = [ "wheel" "networkmanager" ];
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

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  hardware.bluetooth.enable = true;
  hardware.raspberry-pi."4".bluetooth.enable = true;

#  systemd.services.btattach = {
#    before = [ "bluetooth.service" ];
#    after = [ "dev-ttyAMA0.device" ];
#    wantedBy = [ "multi-user.target" ];
#    serviceConfig = {
#      ExecStart = "${pkgs.bluez}/bin/btattach -B /dev/ttyAMA0 -P bcm -S 3000000";
#    };
#  };

  hardware.enableRedistributableFirmware = true;
  system.stateVersion = "23.11";
}
