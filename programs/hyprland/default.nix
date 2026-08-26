{ pkgs-unstable, ... }:
{
  wayland.windowManager = {
    hyprland = {
      package = pkgs-unstable.hyprland;
      enable = true;
      configType = "lua";
      extraConfig = builtins.readFile ./hyprland-with-dms.lua;
      systemd.enable = false;
    };
  };
}
