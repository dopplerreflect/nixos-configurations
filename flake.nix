{
  description = "NixOS Configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # zen-browser = {
    #   url = "github:0xc000022070/zen-browser-flake";
    #   # IMPORTANT: we're using "libgbm" and is only available in unstable so ensure
    #   # to have it up-to-date or simply don't specify the nixpkgs input
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  outputs =
    {
      nixpkgs,
      nixos-hardware,
      home-manager,
      ...
    }@inputs:
    {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;
      nixosConfigurations = {
        thinkpad = nixpkgs.lib.nixosSystem {
          specialArgs = inputs;
          modules = [
            ./hosts/thinkpad/hardware-configuration.nix

            {
              nixpkgs = {
                hostPlatform = "x86_64-linux";
              };
            }
            ./hosts/common.nix
            ./hosts/thinkpad
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.doppler = {
                  imports = [
                    ./hosts/thinkpad/home.nix
                    # inputs.zen-browser.homeModules.beta
                  ];
                };
              };
            }
          ];
        };
        pi = nixpkgs.lib.nixosSystem {
          specialArgs = inputs;
          modules = [
            { nixpkgs.hostPlatform = "aarch64-linux"; }
            nixos-hardware.nixosModules.raspberry-pi-4
            ./hosts/common.nix
            ./hosts/pi
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.doppler = import ./hosts/pi/home.nix;
              };
            }
          ];
        };
        x86_64-iso = nixpkgs.lib.nixosSystem {
          specialArgs = inputs;
          modules = [
            { nixpkgs.hostPlatform = "x86_64-linux"; }
            (
              {
                pkgs,
                modulesPath,
                ...
              }:
              {
                imports = [
                  (modulesPath + "/installer/cd-dvd/installation-cd-minimal-new-kernel-no-zfs.nix")
                  ./programs/git.nix
                ];
                networking = {
                  wireless.enable = false;
                  networkmanager.enable = true;
                };
                console = {
                  earlySetup = true;
                  font = "${pkgs.powerline-fonts}/share/consolefonts/ter-powerline-v28b.psf.gz";
                  packages = with pkgs; [ powerline-fonts ];
                  keyMap = "dvorak";
                };
                nix = {
                  package = pkgs.nixVersions.stable;
                  extraOptions = "experimental-features = nix-command flakes";
                };
                environment.systemPackages = with pkgs; [
                  tmux
                  vim
                  git
                ];
              }
            )
          ];
        };
      };
    };
}
