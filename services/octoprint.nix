{ pkgs, ... }:

{
  services.octoprint = {
    enable = true;

    plugins = ps: [
      (ps.buildPythonPackage rec {
        pname = "OctoPrint-BambuPrinter";
        version = "0.1.8rc17";

        pyproject = true;

        src = pkgs.fetchFromGitHub {
          owner = "jneilliii";
          repo = "OctoPrint-BambuPrinter";
          rev = version;
          hash = "sha256-JQe8UuVorhQJez7tCt+8nKmrHStE0gPJruf5Met+fNE=";
        };

        build-system = [
          ps.setuptools
        ];

        dependencies = [
          ps.pillow
          ps.paho-mqtt
          ps.requests
          ps.python-dateutil
          ps.packaging
          ps.beautifulsoup4
        ];

        # The bundled tests aren't needed to install the plugin.
        doCheck = false;
      })
    ];
  };
}
