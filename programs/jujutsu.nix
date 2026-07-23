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
        default-command = [ "log" "--reversed" "-n" "10" ];
        editor = "${pkgs.helix}/bin/hx";
        paginate = "never";
        color = "always";
      };
      aliases = {
        bmm = [ "bookmark" "move" "main" "--to=@-" ];
        d = [ "describe" "-m" ];
        gp = [ "git" "push" ];
      };
    };
  };
}
