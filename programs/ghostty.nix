{ ... }:
{
  programs.ghostty = {
    enable = true;
    # settings = {
    #   theme = "Dark Pastel"; # Matches well with dark material palettes
    #   font-family = "JetBrains Mono";
    #   font-size = 12;

    #   # Clean Wayland integration
    #   window-decoration = false;
    #   background-opacity = 0.95;

    #   # Ensures smooth clipboard sharing in a pure Wayland environment
    #   clipboard-read = "allow";
    #   clipboard-write = "allow";

    #   # Disable Ghostty's native split shortcuts so they never conflict with tmux/Niri
    #   keybind = [
    #     "super+shift+d=unbind"
    #     "super+d=unbind"
    #   ];
    # };
  };
}
