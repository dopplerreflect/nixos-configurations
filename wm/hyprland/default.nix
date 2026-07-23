{
  ...
}:
{
  wayland.windowManager = {
    hyprland = {
      enable = true;
      configType = "lua";
      extraConfig = ''
        hl.exec_cmd("echo -n bb | gnome-keyring-daemon --replace --unlock")
        hl.exec_cmd("hyprctl setcursor Bibata-Modern-Ice 24")
        require('dms.hyprland')
      '';
      # extraConfig = lib.fileContents ./hyprland.lua;
      # xwayland.enable = false; # this causes cache.nixos.org miss and thus has to build from source
    };
  };

  # home = {
  #   packages = with pkgs; [
  #     brightnessctl
  #     hyprlock
  #     hyprshot
  #     libnotify
  #     swaynotificationcenter
  #     awww
  #     wl-clipboard
  #     wlroots
  #     xdg-desktop-portal-hyprland
  #   ];
  # };

  # services.hypridle.enable = true;

  # imports = [
  #   ./cycle-desktop-background
  #   ./hyprscale
  #   ./toggle-hypridle
  # ];

  # xdg.configFile = {
  #   "hypr/hypridle.conf".source = ./hypridle.conf;
  #   "hypr/hyprlock.conf".source = ./hyprlock.conf;
  #   "hypr/parts" = {
  #     source = ./parts;
  #     recursive = true;
  #   };
  # };
}
