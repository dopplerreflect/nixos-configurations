{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      timeout = 0;
    };
    plymouth = {
      enable = true;
      theme = "rings";
      themePackages = with pkgs; [
        (adi1090x-plymouth-themes.override {
          selected_themes = ["rings"];
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
  };

  networking = {
    hostName = "nixos-qemu";
    networkmanager.enable = true;
    firewall.allowedTCPPorts = [22 80];
  };

  programs.dconf.enable = true;

  users.users.doppler = {
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager"];
    shell = pkgs.zsh;
    packages = with pkgs; [
    ];
  };

  services = {
    gvfs.enable = true;
    gnome.gnome-keyring.enable = true;
    displayManager = {
      defaultSession = "xfce";
      autoLogin = {
        enable = true;
        user = "doppler";
      };
    };
    xserver = {
      enable = true;
      desktopManager.xfce.enable = true;
      xkb = {
        layout = "us";
        variant = "dvorak";
        options = "ctrl:nocaps";
      };
      excludePackages = with pkgs; [xterm];
    };
    picom = {
      enable = true;
      fade = true;
      inactiveOpacity = 0.8;
      shadow = true;
      fadeDelta = 4;
    };
  };

  environment = {
    sessionVariables = rec {
      GTK_THEME = "Adwaita:dark";
      PATH = ["$HOME/.local/bin"];
    };
  };

  security = {
    rtkit.enable = true;
    polkit.enable = true;
  };

  hardware.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  hardware.rtl-sdr.enable = true;

  fonts.packages = with pkgs; [
    (nerdfonts.override {fonts = ["FiraCode"];})
    corefonts
    dejavu_fonts
    terminus_font
  ];

  nix = {
    package = pkgs.nixVersions.stable;
    extraOptions = "experimental-features = nix-command flakes";
  };

  system.stateVersion = "24.11"; # Did you read the comment?
}
