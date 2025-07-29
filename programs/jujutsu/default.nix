{ pkgs, ... }:
{
  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        email = "doppler@gmail.com";
        name = "David Rose";
      };
      ui = {
        default-command = [ "log" "--reversed" ];
        editor = "${pkgs.helix}/bin/hx";
        paginate = "never";
      };
    };
  };
}
