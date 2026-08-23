{ pkgs-stable, ... }:
{
  home.packages = [ pkgs-stable.kitty ];
  xdg.configFile = {
    "kitty/kitty.conf".source = ./kitty.conf;
  };

  programs.ssh.extraConfig = ''
    Host pi
      HostName pi
      User doppler
      RemoteCommand kitty +kitten ssh %h
      RequestTTY yes
  '';
}
