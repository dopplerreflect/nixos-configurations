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
      nms = "nmcli device wifi list --rescan yes";
      nmc = "nmcli device wifi connect";
      pi = "ssh pi";
      ssh = "kitten ssh";
    };
  };
}
