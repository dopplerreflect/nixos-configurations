{
  pkgs,
  config,
  lib,
  ...
}:
let
  isThinkpad = config.networking.hostName == "thinkpad";
in
{
  home-manager.users.doppler = {
    home = {
      packages = with pkgs; [
        bat
        eza
        fastfetch
        zoxide
      ];
    };
    programs = {
      oh-my-posh = {
        enable = true;
        enableFishIntegration = true;
        useTheme = "slim";
      };
      fish = {
        enable = true;

        shellAliases =
          {
            cat = "bat";
            la = "ls -lAh --git";
            ll = "ls -lh --git";
            ls = "eza";
            nms = "nmcli device wifi list --rescan yes";
            nmc = "nmcli device wifi connect";
          }
          // lib.optionalAttrs isThinkpad {
            code = "codium";
            hs = "hyprscale";
            pi = "ssh pi";
            ssh = "kitten ssh";
          };

      };
      zoxide = {
        enable = true;
        options = [ "--cmd cd" ];
      };
    };
  };
}
