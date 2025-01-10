{ pkgs, ... }:
{
  home = {
    username = "doppler";
    homeDirectory = "/home/doppler";

    packages = with pkgs; [
      bat
      btop
      eza
    ];

    file = {
      "start-ecowitt.sh".text = builtins.readFile ./start-ecowitt.sh;
    };

    stateVersion = "24.05";
  };
}
