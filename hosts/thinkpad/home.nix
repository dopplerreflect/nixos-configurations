{ pkgs, ...}:

{
  home = {
    username = "doppler";
    homeDirectory = "/home/doppler";
    packages = with pkgs; [
      # ags # this is in nix profile instead due to broken upstream build
      bitwarden
      brave
      btop
      # gqrx
      imv
      kitty
      mpv
      nautilus
      nextcloud-client
      nodejs
      pnpm
      virt-manager
      virt-viewer
      vscodium
      wavemon
      xfce.thunar
      xfce.thunar-volman
      xfce.tumbler
      xfce.xfconf
      yarn
      yazi
    ];
    file = {
      ".config/kitty/kitty.conf".source = ./.config/kitty/kitty.conf;
      "./.local/share/applications" = {
        source = ./.local/share/applications;
        recursive = true;
      };
      "./.local/bin" = {
        source = ./.local/bin;
        recursive = true;
      };
    };
    stateVersion = "24.05";
  };
  
  imports = [
    ./hyprland
  ];

  gtk = {
    enable = true;
    theme = {
      package = pkgs.andromeda-gtk-theme;
      name = "Andromeda";
    };
    iconTheme = {
      package = pkgs.beauty-line-icon-theme;
      name = "BeautyLine";
    };
  };
}
