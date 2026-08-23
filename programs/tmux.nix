{ pkgs-stable, ... }:
{
  programs.tmux = {
    enable = true;
    package = pkgs-stable.tmux;
    baseIndex = 1;
    escapeTime = 0;
    plugins = with pkgs-stable; [
      tmuxPlugins.tokyo-night-tmux
    ];
  };
}
