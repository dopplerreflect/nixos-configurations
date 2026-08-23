{
  config,
  lib,
  pkgs-stable,
  ...
}:
let
  isThinkpad = config.networking.hostName == "thinkpad";
in
{
  home-manager.users.doppler = {
    home = {
      packages = with pkgs-stable; [
        bat
        eza
        fastfetch
        zoxide
      ];
    };
    programs = {
      oh-my-posh = {
        package = pkgs-stable.oh-my-posh;
        enable = true;
        useTheme = "sonicboom_dark";
      };
      zsh = {
        package = pkgs-stable.zsh;
        enable = true;
        enableCompletion = true;
        autosuggestion = {
          enable = true;
          strategy = [
            "completion"
            "history"
            "match_prev_cmd"
          ];
        };
        initContent = ''
          setopt NO_CASE_GLOB
        '';
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
            pi = "ssh pi";
          };
      };
      zoxide = {
        package = pkgs-stable.zoxide;
        enable = true;
        options = [ "--cmd cd" ];
      };
    };
  };
}
