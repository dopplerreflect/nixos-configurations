{ pkgs, ... }:
{
  programs = {
    helix = {
      enable = true;
      extraPackages = with pkgs; [
        astro-language-server
        # prettier
        svelte-language-server
        tailwindcss-language-server
        typescript-language-server
        vscode-css-languageserver
        # lemminx
      ];
      settings = {
        theme = "doppler";
        editor = {
          bufferline = "multiple";
        };
        editor = {
          file-picker = {
            follow-symlinks = false;
            hidden = false;
          };
        };
      };
      themes = {
        doppler = {
          inherits = "tokyonight";
          function = { fg = "blue"; };
          keyword = { fg = "purple"; };
          "ui.background"= {};
        };
      };
      languages = {
        language-server.astro-ls = {
          command = "astro-ls";
          args = [ "--stdio" ];
        };
        language-server.tailwind-ls = {
          command = "tailwindcss-language-server";
          args = [ "--stdio" ];
        };
        # language-server.lemminx = {
        #   command = "lemminx";
        # };
        language = [
          {
            name = "astro";
            file-types = ["astro"];
            roots = ["package.json" "astro.config.mjs"];
            language-servers = ["astro-ls" "typescript-language-server"];
            formatter.command = "prettier";
            formatter.args = [ "--parser" "astro" ];
            auto-format = true;
          }
          {
            name = "typescript";
            formatter.command = "prettier";
            formatter.args = [ "--parser" "typescript" ];
            auto-format = true;
          }
          {
            name = "svelte";
            language-servers = [ "svelteserver" ];
            formatter.command = "yarn";
            formatter.args = [ "dlx" "-q" "-p" "prettier@~3.6.1" "prettier" "--parser" "svelte" ];
            auto-format = true;
          }
          # {
          #   name = "xml";
          #   file-types = [ "xml" "svg" ];
          #   language-servers = [ "lemminx" ];
          #   auto-format = true;
          # }
        ];
      };
    };
  };
}
