{ lib, pkgs, ... }:

let
  pname = "orca-slicer-appimage";
  version = "2.5.2";

  src = pkgs.fetchurl {
    url =
      "https://github.com/OrcaSlicer/OrcaSlicer/releases/download/v${version}/"
      + "OrcaSlicer_Linux_AppImage_Ubuntu2404_V${version}.AppImage";

    # Replace with the "got:" hash reported by the first build.
    hash = "sha256-IvqIiE3sP9vSnpDLqZEvz/b7V6YLG9wabBicYaawqHA=";
  };

  appimageContents = pkgs.appimageTools.extractType2 {
    inherit pname version src;
  };

  desktopItem = pkgs.makeDesktopItem {
    name = pname;
    desktopName = "OrcaSlicer";
    genericName = "3D Printing Slicer";
    comment = "Prepare 3D models for printing";
    exec = "${pname} %F";
    icon = pname;
    terminal = false;
    categories = [ "Graphics" "3DGraphics" "Engineering" ];
    startupNotify = true;
  };

  orcaSlicer = pkgs.appimageTools.wrapType2 {
    inherit pname version src;

    extraPkgs = pkgs: [
      pkgs.webkitgtk_4_1
      pkgs.libsoup_3
    ];

    extraInstallCommands = ''
      install -Dm444 \
        ${desktopItem}/share/applications/${pname}.desktop \
        "$out/share/applications/${pname}.desktop"

      # Prefer an OrcaSlicer icon rather than an unrelated bundled asset.
      icon="$(find -L ${appimageContents} \
        -type f -iname '*orca*.svg' -print -quit)"

      if [ -n "$icon" ]; then
        install -Dm444 "$icon" \
          "$out/share/icons/hicolor/scalable/apps/${pname}.svg"
      else
        icon="$(find -L ${appimageContents} \
          -type f -iname '*orca*.png' -print -quit)"

        if [ -n "$icon" ]; then
          install -Dm444 "$icon" \
            "$out/share/pixmaps/${pname}.png"
        fi
      fi
    '';

    meta = {
      description = "OrcaSlicer 3D printing slicer, packaged from its AppImage";
      homepage = "https://github.com/OrcaSlicer/OrcaSlicer";
      mainProgram = pname;
      platforms = [ "x86_64-linux" ];
    };
  };
in
{
  environment.systemPackages = [
    orcaSlicer
  ];
}
