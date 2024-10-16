{ pkgs, ... }: {

	imports = [
	];

	programs = {
		fish.functions = {
			osu = {
				body = ''
					ssh <USER>@flip1.engr.oregonstate.edu
				'';
			};
			osutransfer = {
				body = ''
					scp $argv <USER>@flip1.engr.oregonstate.edu:~/transfer
				'';
			};
			osuweb = {
				body = ''
					scp $argv <USER>@flip1.engr.oregonstate.edu:~/public_html
				'';
			};
		};
	};
}
