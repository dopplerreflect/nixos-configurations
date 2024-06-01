{ config, pkgs, lib, ... }:

{
  imports = [
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
    hostName = "nixpi";
    firewall.enable = false;
    wireless = {
      enable = true;
      networks."Spaceland-Public".psk = null;
      interfaces = [ "wlp1s0u1u2" ];
    };
  };

  services.create_ap = {
    enable = true;
    settings = {
      INTERNET_IFACE = "wlp1s0u1u2";
      WIFI_IFACE = "wlan0";
      SSID = "weatherflow";
      PASSPHRASE = "wifipass";
    };
  };

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    earlySetup = true;
    font = "${pkgs.terminus_font}/share/consolefonts/ter-132n.psf.gz";
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
      # ExecStop = "${pkgs.tmux}/bin/tmux kill-session -t wf";
    };
  };

  environment.systemPackages = with pkgs; [ 
    git
    linux-wifi-hotspot
    nodejs
    tmux
    vim 
    yarn
  ];

  environment.variables = { EDITOR = "vim"; };

  services.openssh.enable = true;

  users = {
    mutableUsers = false;
    users.doppler = {
      isNormalUser = true;
      password = "bb";
      extraGroups = [ "wheel" ];
    };
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  hardware.bluetooth.enable = true;
  hardware.raspberry-pi."4".bluetooth.enable = true;

  systemd.services.btattach = {
    before = [ "bluetooth.service" ];
    after = [ "dev-ttyAMA0.device" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.bluez}/bin/btattach -B /dev/ttyAMA0 -P bcm -S 3000000";
    };
  };

  hardware.enableRedistributableFirmware = true;
  system.stateVersion = "23.11";
}
