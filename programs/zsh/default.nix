{
  config,
  lib,
  pkgs,
  home-manager,
  ...
}: let
  isThinkpad = config.networking.hostName == "thinkpad";
in {
  home-manager.users.doppler.home = {
    packages = with pkgs; [
      bat
      eza
      fastfetch
      zoxide
    ];
    file = {
      ".zprofile".source = ./.zprofile;
      ".zshrc".source = ./.zshrc;
    };
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    ohMyZsh = {
      enable = true;
      plugins = ["git"];
      theme =
        if isThinkpad
        then "half-life"
        else "jreese";
    };
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
}
