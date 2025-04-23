{
  config,
  lib,
  pkgs,
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
      file = {
        ".zprofile".source = ./.zprofile;
      };
    };
    programs = {
      oh-my-posh = {
        enable = true;
        settings = builtins.fromJSON (
          builtins.unsafeDiscardStringContext (builtins.readFile ./velvet-custom.omp.json)
        );
      };
      zsh = {
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
