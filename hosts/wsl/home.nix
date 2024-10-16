# home.nix

{ inputs, pkgs, lib, username, ... }: {

	imports = [
		# neovim with config
		(import ../../modules/neovim)

		# tmux with config
		(import ../../modules/tmux)

		# use FiraCode nerdfont w/ symbols
		(import ../../modules/firacode)

		# use cowsay and fortune for a 'say' command
		(import ../../modules/say-fortune)

		# starship prompt
		(import ../../modules/starship)

		# git with fish functions
		(import ../../modules/git)

		# pkgs for accessing osu servers
		(import ../../modules/osu)

		# dev package for C
		(import ../../modules/dev/C)

		# dev package for C++
		(import ../../modules/dev/Cpp)
	];

	# Home manager config
	home = {
		stateVersion = "24.05";

		username = "${username}";
		homeDirectory = "/home/${username}";

		# Personal editor & shell
		sessionVariables.EDITOR = "nvim";
		sessionVariables.SHELL = "/etc/profiles/per-user/${username}/bin/fish";

		# overwriting default functions wasn't working in fish, so it's here
		shellAliases = {
			ls = "eza --icons";
			la = "eza -a --icons";
		};

		packages = with pkgs; [
			gum
			soft-serve
			glow
			unzip
			ripgrep
			cloc
		];
	};

	fonts.fontconfig.enable = true;

	# all built-in to home manager programs
	# also has their configs
	programs = {

		home-manager = { enable = true; };

		eza = { enable = true; };

		zoxide = { enable = true; };

		fzf = { enable = true; };

		fish = {
			enable = true;
			functions = {
				x = {
					body = ''
						exit
					'';
				};
				lz = {
					body = ''
						eza -a -l -h --git --git-repos --no-user --total-size --icons
					'';
				};
				c = {
					body = ''
						clear
					'';
				};
				cl = {
					body = ''
						c
						ls
					'';
				};
				fetch = {
					body = ''
						/etc/nixos/WSL-Nix-Basis/misc/fetches/diyfetch-wsl
					'';
				};
				desk = {
					body = ''
						c
						z ~
						fetch
						ls
						'';
				};
				rebuild = {
					body = ''
						sudo nixos-rebuild switch --flake /etc/nixos/WSL-Nix-Basis#wsl
					'';
				};
				config = {
					body = ''
						nvim /etc/nixos/WSL-Nix-Basis/hosts/wsl/home.nix
					'';
				};
				condir = {
					body = ''
						z /etc/nixos/WSL-Nix-Basis/
					'';
				};
			};
		};	
	};
}
