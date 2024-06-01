{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }@attrs: {

		nixosConfigurations = {
			nixpi = nixpkgs.lib.nixosSystem {
				system = "aarch64-linux";
				specialArgs = attrs;
				modules = [
					./hosts/nixpi
				];
			};
		};
		
  };
}
