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

#  services = {
#    xserver = {
#      enable = true;
#      # displayManager.gdm.enable = true;
#      # desktopManager.gnome.enable = true;
#      displayManager = {
#        gdm = {
#          enable = true;
#          wayland =true;
#        };
#      };
#      desktopManager.gnome.enable = true;
#      xkb = {
#        layout = "us";
#        variant = "dvorak";
#        options = "ctrl:nocaps";
#      };
#      excludePackages = with pkgs; [ xterm ];
#    };
#  };
#  services.gnome.gnome-browser-connector.enable = true;
#
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

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
    extraGroups = [ "networkmanager" "wheel" "libvirtd" "docker" ];
    shell = pkgs.zsh;
  };

  environment.systemPackages = with pkgs; [
  ];

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraPackages = with pkgs; [
      alacritty
      dmenu
      wofi
      swaylock
      swayidle
      swaybg
      wl-clipboard
      mako
      i3status-rust
      nwg-launchers
      nwg-bar
    ];
  };

  environment.variables = {
    UV_USE_IO_URING = 0; # workaround for https://github.com/nodejs/node/issues/53051
  };
  environment.sessionVariables = {
    GTK_THEME = "Adwaita-dark";
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
  # fonts = {
  #   fontDir.enable = true;
  #   enableGhostscriptFonts = true;
  #   fonts = with pkgs; [
  #     corefonts
  #     terminus_font
  #     inconsolata
  #     dejavu_fonts
  #     font-awesome-ttf
  #     source-code-pro
  #     source-sans-pro
  #     source-serif-pro
  #   ];
  # };


  system.stateVersion = "22.05"; # Did you read the comment?

  # security.sudo.wheelNeedsPassword = false;
  # nixpkgs.config.allowUnfree = true;

  # services.sshd.enable = true;

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

}
