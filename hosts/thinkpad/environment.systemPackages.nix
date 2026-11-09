{ pkgs, inputs,... }:
{
  environment.systemPackages = with pkgs; [
    android-tools
    authenticator
    bitwarden-desktop
    blender
    # brave
    btop
    bun
    inputs.dgop.packages.${pkgs.stdenv.hostPlatform.system}.default
    ffmpegthumbnailer
    freecad
    gimp3
    google-chrome
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
    ripgrep
    scrcpy
    unzip
    virt-manager
    virt-viewer
    wf-recorder
    wl-clipboard
    xwayland-satellite
    yarn    
  ];
}
