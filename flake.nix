{
  description = "NixOS Configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    # nixpkgs.url = "/home/doppler/Code/nixpkgs";
    # nixos-24-11.url = "github:nixos/nixpkgs?ref=nixos-24.11";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Cosmic Desktop
    nixpkgs.follows = "nixos-cosmic/nixpkgs";
    nixos-cosmic.url = "github:lilyinstarlight/nixos-cosmic";
    # Lix
    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.92.0.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # For getting the cachyos kernel
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
  };

  outputs =
    {
      nixpkgs,
      # nixos-24-11,
      nixos-hardware,
      home-manager,
      # Cosmic Desktop
      nixos-cosmic,
      # Lix
      lix-module,
      # Chaotic
      chaotic,
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
                # overlays = [
                #   (_: prev: {
                #     nixos-24-11 = nixos-24-11.legacyPackages.${prev.system};
                #   })
                # ];
              };
              # Cosmic Desktop
              nix.settings = {
                substituters = [ "https://cosmic.cachix.org/" ];
                trusted-public-keys = [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" ];
                trusted-users = [
                  "root"
                  "doppler"
                  "@wheel"
                ];
              };
            }
            ./hosts/common.nix
            # Cosmic Desktop
            nixos-cosmic.nixosModules.default
            ./hosts/thinkpad
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.doppler = import ./hosts/thinkpad/home.nix;
              };
            }
            # Lix
            lix-module.nixosModules.default
            # ? cachyos kernel ?
            chaotic.nixosModules.default
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
        # nixos-qemu = nixpkgs.lib.nixosSystem {
        #   system = "x86_64-linux";
        #   specialArgs = inputs;
        #   modules = [
        #     ./hosts/common.nix
        #     ./hosts/nixos-qemu
        #     home-manager.nixosModules.home-manager
        #     {
        #       home-manager = {
        #         useGlobalPkgs = true;
        #         useUserPackages = true;
        #         users.doppler = import ./hosts/nixos-qemu/home.nix;
        #       };
        #     }
        #   ];
        # };
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
                  (modulesPath + "/installer/cd-dvd/installation-cd-graphical-calamares-gnome.nix")
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
