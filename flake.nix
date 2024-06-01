{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
		nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = { self, nixpkgs, nixos-hardware, ... }@attrs: {

		nixosConfigurations = {
			nixpi = nixpkgs.lib.nixosSystem {
				system = "aarch64-linux";
				specialArgs = attrs;
				modules = [
					nixos-hardware.nixosModules.raspberry-pi-4
					./hosts/nixpi
				];
			};
		};
		
  };
}
