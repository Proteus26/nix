{
  description = "Dendritic NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nh = {
      url = "github:viperML/nh";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    inputs@{ self, nixpkgs, flake-parts, home-manager, nh, ... }:
    let
			# Identity shared by every module system
      hostspec = {
        hostname = "nix";
        username = "proteus";
        stateVersion = "26.05";
        system = "x86_64-linux";
      };
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ hostspec.system ];

      perSystem =
        { system, ... }:
        let
          pkgs = import nixpkgs {
            inherit system;
            config = {
              allowUnfree = true;
              cudaSupport = true;
            };
          };
        in
        {
          _module.args.pkgs = pkgs;

          devShells = import ./devshells { inherit pkgs; };
        };

      flake = {
        nixosConfigurations."${hostspec.hostname}" = nixpkgs.lib.nixosSystem {
          system = hostspec.system;
          specialArgs = { inherit hostspec inputs; };
          modules = [
            ./hosts/nix
            home-manager.nixosModules.home-manager
          ];
        };
      };
    };
}
