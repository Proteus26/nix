{
  description = "NixOS + home-manager configuration (Hyprland)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts.url = "github:hercules-ci/flake-parts";

    figma-linux-next = {
      url = "github:arximus88/figma-linux-next";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      nixpkgs,
      flake-parts,
      home-manager,
      ...
    }:
    let
      # Identity shared by every module system
      hostspec = {
        hostname = "nix";
        username = "proteus";
        stateVersion = "26.05";
        system = "x86_64-linux";
      };

      # One nixpkgs instance for devshells and standalone home-manager.
      pkgs = import nixpkgs {
        inherit (hostspec) system;
        config.allowUnfree = true;
      };
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ hostspec.system ];

      perSystem = {
        _module.args.pkgs = pkgs;

        devShells = import ./devshells { inherit pkgs; };

        # `nix fmt` formats every .nix file in the repo.
        formatter = pkgs.nixfmt-tree;
      };

      flake = {
        lib.mergeDevShells = import ./devshells/merge.nix {
          inherit pkgs;
          shells = import ./devshells { inherit pkgs; };
        };

        nixosConfigurations.${hostspec.hostname} = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit hostspec inputs; };
          modules = [
            ./hosts/nix
            home-manager.nixosModules.home-manager
          ];
        };

        # Standalone home-manager (no sudo). Shares modules/home with the
        # NixOS module above; prefer `nh os switch` so the two don't fight.
        homeConfigurations.${hostspec.username} = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit hostspec inputs; };
          modules = [ ./modules/home ];
        };
      };
    };
}
