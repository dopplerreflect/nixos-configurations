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
        default-command = [ "log" ];
        editor = "${pkgs.helix}/bin/hx";
        paginate = "never";
      };
      aliases = {
        bmm = [ "bookmark" "move" "main" "--to=@-" ];
        gp = [ "git" "push" ];
      };
    };
  };
}
