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
  #   userName = "David Rose";
  #   userEmail = "doppler@gmail.com";
  #   aliases = {
  #     co = "checkout";
  #     st = "status";
  #     br = "branch";
  #     ci = "commit";
  #   };
  };
}