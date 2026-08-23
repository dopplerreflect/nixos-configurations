{ pkgs-stable, ... }:
{
  programs.neovim = {
    enable = true;
    package = pkgs-stable.neovim-unwrapped;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    configure = {
      customRC = ''
        set expandtab
        set shiftwidth=2
        set softtabstop=2
      '';
    };
  };
}
