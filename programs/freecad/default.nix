{ pkgs, lib, ... }:

pkgs.appimageTools.wrapType2 rec {
  pname = "freecad";
  version = "weekly-2026.11.18";

  src = pkgs.fetchurl {
    url = "https://github.com/FreeCAD/FreeCAD/releases/download/${version}/FreeCAD_${version}-Linux-x86_64.AppImage";
    hash = "sha256-PT5eqJ+e2tih8VHh1GVKH+A1+UTD1U40CaKuAzpuNoc=";
  };

  appimageContents = pkgs.appimageTools.extractType2 {
    inherit pname version src;
  };

  # Add any extra libraries the AppImage expects from the host system
  extraPkgs = pkgs: with pkgs; [
    libGL
    libxkbcommon
    wayland
    mesa
    intel-media-driver
  ];

  extraInstallCommands = ''
    # Install the .desktop file and icons so your app launcher finds it
    install -m 444 -D ${appimageContents}/org.freecad.FreeCAD.desktop $out/share/applications/org.freecad.FreeCAD.desktop
    substituteInPlace $out/share/applications/org.freecad.FreeCAD.desktop \
      --replace-fail 'Exec=AppRun' 'Exec=${pname}'

    cp -r ${appimageContents}/usr/share/icons $out/share/

    # Wrap the binary to handle Wayland/XWayland and Intel iGPU quirks cleanly
    source "${pkgs.makeWrapper}/nix-support/setup-hook"
    wrapProgram $out/bin/${pname} \
      --unset APPIMAGE \
      --unset APPDIR \
      --set QT_QPA_PLATFORM "xcb"
  '';

  meta = with lib; {
    description = "General purpose Open Source 3D CAD/MCAD/CAx/CAE/PLM modeler (AppImage)";
    homepage = "https://www.freecad.org/";
    license = licenses.lgpl2Plus;
    platforms = [ "x86_64-linux" ];
  };
}
