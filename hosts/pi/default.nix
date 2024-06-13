{ config, pkgs, lib, ... }:

{
  security.sudo.wheelNeedsPassword = false;

  imports = [
    ../common
    ./bluetooth.nix
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
    firewall.enable = false;
    extraHosts = "192.168.12.3 GW2000X\n192.168.12.2 thinkpad";
    #wireless = {
    #  enable = true;
    #  networks."Spaceland-Public".psk = null;
    #  interfaces = [ "wlp1s0u1u2" ];
    #};
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
      INTERNET_IFACE = "wlp1s0u1u2";
      WIFI_IFACE = "wlan0";
      SSID = "weatherflow";
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

  systemd.services.svelte-weatherflow = {
    description = "Svelte Weatherflow Webapp";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    serviceConfig = {
      Type = "forking";
      User = "doppler";
      WorkingDirectory = "/home/doppler";
      ExecStart = "/home/doppler/start-wf.sh";
    };
  };

  environment.systemPackages = with pkgs; [ 
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
