{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    authenticator
    brave
    btop
    bun
    googleearth-pro
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
    unzip
    virt-manager
    virt-viewer
    vlc
    wf-recorder
    wl-clipboard
    yarn    
  ];
}
