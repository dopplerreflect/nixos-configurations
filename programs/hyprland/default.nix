{
  ...
}:
{
  wayland.windowManager = {
    hyprland = {
      enable = true;
      configType = "lua";
      extraConfig = builtins.readFile ./hyprland-with-dms.lua;
      systemd.enable = false;
    };
  };
}
