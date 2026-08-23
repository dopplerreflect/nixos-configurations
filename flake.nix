{
  description = "NixOS Configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-26.05";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dms = {
      url = "github:AvengeMedia/DankMaterialShell/stable";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      nixpkgs-stable,
      nixos-hardware,
      home-manager,
      ...
    }@inputs:
    {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt;
      nixosConfigurations = {
        thinkpad = let
          system = "x86_64-linux";
        in nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs;
            pkgs-stable = nixpkgs-stable.legacyPackages.${system};
          };
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
                extraSpecialArgs = {
                  pkgs-stable = nixpkgs-stable.legacyPackages.${system};
                };
                users.doppler = {
                  imports = [
                    ./hosts/thinkpad/home.nix
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
      };
    };
}
