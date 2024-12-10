{pkgs, ...}: {
  home = {
    packages = [
      pkgs.bc
    ];
    file."./.local/bin/hyprscale".source = ./hyprscale;
  };
}
