{
  config,
  pkgs,
  ...
}: {
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
        br = "branch";
        ci = "commit";
        co = "checkout";
        st = "status";
        sw = "switch";
      };
    };
  };
}
