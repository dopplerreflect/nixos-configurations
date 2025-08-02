{ pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    escapeTime = 0;
    plugins = with pkgs; [
      tmuxPlugins.tokyo-night-tmux
    ];
  };
}
