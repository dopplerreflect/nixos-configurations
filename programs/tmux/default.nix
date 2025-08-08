{ pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    baseIndex = 1;
    escapeTime = 0;
    plugins = with pkgs; [
      tmuxPlugins.tokyo-night-tmux
    ];
  };
}
