{ config, pkgs, lib, ... }:

{
  security.sudo.wheelNeedsPassword = false;

  imports = [
    ../common
    ./bluetooth.nix
  ];

  users = {
    mutableUsers = false;
    users.justin = {
      isNormalUser = true;
      password = "justin";
      extraGroups = [ "wheel" "networkmanager" ];
    };
  };

  services.create_ap = {
    enable = true;
    settings = {
      INTERNET_IFACE = "wlp1s0u1u2";
      WIFI_IFACE = "wlan0";
      SSID = "pi-ap";
      PASSPHRASE = "wifipass";
    };
  };

  networking = {
    hostName = "pi";
    firewall.enable = false;
  };

  environment.systemPackages = with pkgs; [ 
    linux-wifi-hotspot
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

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    earlySetup = true;
    font = "${pkgs.terminus_font}/share/consolefonts/ter-124n.psf.gz";
    packages = with pkgs; [ terminus_font ];
    # keyMap = "dvorak";
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
