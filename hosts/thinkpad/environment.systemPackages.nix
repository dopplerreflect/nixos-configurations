{ pkgs, pkgs-stable, ... }:
{
  environment.systemPackages = with pkgs-stable; [
    authenticator
    blender
    brave
    btop
    bun
    freecad
    gimp3
    imv
    inkscape
    librsvg
    mpv
    nautilus
    nextcloud-client
    nixd
    nixfmt
    nodejs
    openscad-unstable
    openscad-lsp
    unzip
    virt-manager
    virt-viewer
    wf-recorder
    wl-clipboard
    yarn    
  ] ++ [
    pkgs.googleearth-pro
  ];
}
