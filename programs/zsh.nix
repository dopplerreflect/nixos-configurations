{ config, pkgs, ...}:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    ohMyZsh = {
      enable = true;
      plugins = [ "git" ];
      theme = if config.networking.hostName == "thinkpad" then "half-life" else "jreese";
    };
    shellAliases = {
      cat = "bat";
      code = "codium";
      ls = "eza";
      ns = "nmcli device wifi list --rescan yes";
      pi = "ssh pi";
      ssh = "kitten ssh";
    };
  };
}
