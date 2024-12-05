{pkgs, ...}: {
  home = {
    username = "doppler";
    homeDirectory = "/home/doppler";
    packages = with pkgs; [
      brave
      fzf
      nautilus
      pulseaudioFull
      vscodium
      xfce.thunar
      xfce.thunar-volman
      xfce.tumbler
      xfce.xfconf
      yazi
    ];
    stateVersion = "24.11";
  };

  imports = [
    ../../programs/kitty
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
