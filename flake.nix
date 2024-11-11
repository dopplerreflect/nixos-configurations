{
  description = "NixOS Configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs-small.url = "github:nixos/nixpkgs?ref=nixos-unstable-small";
    # nixpkgs.url = "/home/doppler/Code/nixpkgs";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-small, nixos-hardware, home-manager, ... }@inputs: {

    nixosConfigurations = {
      pi = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        specialArgs = inputs;
        modules = [
          nixos-hardware.nixosModules.raspberry-pi-4
          ./hosts/common.nix
          ./hosts/pi
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.doppler = import ./hosts/pi/home.nix;
          }
        ];
      };
      thinkpad = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = inputs;
        modules = [
          {
            nixpkgs.overlays = [(final: prev: {
              unstable-small = nixpkgs-small.legacyPackages.${prev.system};
            })];
          }
          ./hosts/common.nix
          ./hosts/thinkpad
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.doppler = import ./hosts/thinkpad/home.nix;
          }
        ];
      };
      nixos-qemu = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = inputs;
        modules = [
          ./hosts/common.nix
          ./hosts/nixos-qemu
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.doppler = import ./hosts/nixos-qemu/home.nix;
          }
        ];
      };
      x86_64-iso = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ({ pkgs, modulesPath, ...}: {
            imports = [
              (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix")
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
            ];
          })
        ];
      };
    };
  };
}
