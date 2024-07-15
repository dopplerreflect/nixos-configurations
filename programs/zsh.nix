{ config, pkgs, ...}:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    ohMyZsh = {
      enable = true;
      plugins = [ "git" ];
      theme = "agnoster";
    };
  };
}