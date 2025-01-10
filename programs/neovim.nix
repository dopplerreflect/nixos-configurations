{ ... }:
{
  programs.neovim = {
    enable = true;
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
