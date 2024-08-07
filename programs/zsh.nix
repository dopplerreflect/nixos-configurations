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
  };
}