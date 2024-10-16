# flake.nix

{
	description = "System flake";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		nix-index-database = {
			url = "github:nix-community/nix-index-database";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		nixos-wsl = {
			url = "github:nix-community/nixos-wsl";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};

	outputs = inputs:
	with inputs; let

		system = "x86_64-linux";

		pkgs = import nixpkgs{
			inherit system;
			config.allowUnfree = true;
		};

		lib = nixpkgs.lib;

	in {
		nixosConfigurations = {
			wsl = lib.nixosSystem {
				inherit system;
				modules = [
					./hosts/wsl/configuration.nix
					nixos-wsl.nixosModules.wsl
					home-manager.nixosModules.home-manager {
						home-manager.useGlobalPkgs = true;
						home-manager.useUserPackages = true;
						home-manager.backupFileExtension = "hm-backup";
						home-manager.extraSpecialArgs = {
							username = "nixos";
						};
						home-manager.users.nixos = {
							imports = [ ./hosts/wsl/home.nix ];
						};
					}

					nix-index-database.nixosModules.nix-index
					{ programs.command-not-found.enable = false; }
				];
			};
		};
	};
}
