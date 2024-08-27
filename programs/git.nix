{ config, pkgs, ...}:

{
  programs.git = {
    enable = true;
    config = {
      init = {
        defaultBranch = "main";
      };
      user = {
        name = "David Rose";
        email = "doppler@gmail.com";
      };
      alias = {
        co = "checkout";
        st = "status";
        br = "branch";
        ci = "commit";
      };
    };
  };
}
