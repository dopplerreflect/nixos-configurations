{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../common
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
    hostName = "thinkpad"; # Define your hostname.
    networkmanager.enable = true;
    extraHosts = "192.168.12.1 pi\n192.168.12.11 ecowitt ecowitt.local GW2000x";
    nameservers = [ "8.8.8.8" ];
    firewall.enable = false;
  };

  time.timeZone = "America/Chicago";
  i18n.defaultLocale = "en_US.utf8";
  console.keyMap = "dvorak";

  services = {
    udisks2 = {
      enable = true;
      mountOnMedia = true;
    };
    gvfs.enable = true;
    gnome.gnome-keyring.enable = true;
    # gnome.tracker-miners.enable = true;
    displayManager.sessionPackages = [ pkgs.sway ];
    xserver = {
      enable = true;
      displayManager = {
        gdm = {
          enable = true;
          wayland =true;
        };
      };
       desktopManager.gnome.enable = true;
      xkb = {
        layout = "us";
        variant = "dvorak";
        options = "ctrl:nocaps";
      };
      excludePackages = with pkgs; [ xterm ];
    };
  };
  # services.gnome.gnome-browser-connector.enable = true;

  services.getty.autologinUser = "doppler";
  environment.loginShellInit = ''
    [[ "$(tty)" == /dev/tty1 ]] && dbus-run-session sway
  '';

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
  programs.zsh.enable = true;

  users.users.doppler = {
    isNormalUser = true;
    description = "doppler";
    extraGroups = [ "networkmanager" "wheel" "libvirtd" "docker" "plugdev" ];
    shell = pkgs.zsh;
  };

  environment.systemPackages = with pkgs; [
    ffmpegthumbnailer
  ];

  environment.variables = {
    UV_USE_IO_URING = 0; # workaround for https://github.com/nodejs/node/issues/53051
  };

  environment.sessionVariables = rec {
    GTK_THEME = "Adwaita:dark";
    PATH = [ "$HOME/.local/bin" ];
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

  system.stateVersion = "22.05"; # Did you read the comment?

  systemd.services.ecowitt = {
    description = "Ecowitt Weather Thing";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    serviceConfig = {
      Type = "forking";
      User = "doppler";
      WorkingDirectory = "/home/doppler/Code/bun-sveltekit-ecowitt";
      ExecStart = "/run/current-system/sw/bin/sh /home/doppler/bin/start-ecowitt.sh";
      ExecStop = "/run/current-system/sw/bin/tmux kill-session -t ecowitt";
    };
  };
  
  nixpkgs.config.permittedInsecurePackages = [ "googleearth-pro-7.3.4.8248" ];

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes";
  };

  environment.gnome.excludePackages = with pkgs.gnome; [
    baobab      # disk usage analyzer
    cheese      # photo booth
    eog         # image viewer
    epiphany    # web browser
    pkgs.gedit       # text editor
    simple-scan # document scanner
    totem       # video player
    yelp        # help viewer
    # evince      # document viewer
    file-roller # archive manager
    geary       # email client
    # seahorse    # password manager

    # these should be self explanatory
    # gnome-calculator
    # gnome-calendar
    gnome-characters
    gnome-clocks
    gnome-contacts
    # gnome-font-viewer
    gnome-logs
    gnome-maps
    gnome-music
    # gnome-photos
    gnome-screenshot
    gnome-system-monitor
    gnome-weather
    # gnome-disk-utility
    pkgs.gnome-connections
  ];
}
