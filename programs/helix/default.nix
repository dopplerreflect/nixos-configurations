{ pkgs, ... }:
{
  programs = {
    helix = {
      enable = true;
      extraPackages = with pkgs; [
        astro-language-server
        prettier
        svelte-language-server
        tailwindcss-language-server
        typescript-language-server
        vscode-css-languageserver
      ];
      settings = {
        theme = "doppler";
        editor = {
          bufferline = "multiple";
        };
        editor.file-picker = {
          hidden = false;
        };
      };
      themes = {
        doppler = {
          inherits = "flexoki_dark";
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
            language-servers = [ "svelteserver" "tailwind-ls" "typescript-language-server" ];
            formatter.command = "prettier";
            formatter.args = [ "--parser" "svelte" ];
            auto-format = true;
          }
        ];
      };
    };
  };
}
