{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    authenticator
    bitwarden-desktop
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
    wl-clipboard
    
  ];
}
