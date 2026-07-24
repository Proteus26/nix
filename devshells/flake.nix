{
  description = "Dev Shells";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
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
        devShells = {
          # C/C++
          cpp = pkgs.mkShell {
            nativeBuildInputs = [
							pkgs.gnumake
              pkgs.cmake
              pkgs.ninja
              pkgs.pkg-config
							pkgs.clang-tools
            ];
            buildInputs = [
              pkgs.gtest
            ];

            shellHook = ''
              if [[ $- == *i* ]] && [ -z "$IN_NIX_SHELL_ZSH" ]; then
                export IN_NIX_SHELL_ZSH=1
                exec ${pkgs.zsh}/bin/zsh
              fi
            '';
          };

          # CUDA
          cuda = pkgs.mkShell {
            nativeBuildInputs = [
              pkgs.cmake
							pkgs.clang-tools
            ];
            buildInputs = [
              pkgs.cudaPackages.cudatoolkit
            ];

            shellHook = ''
              export CUDA_PATH=${pkgs.cudaPackages.cudatoolkit}
              export LD_LIBRARY_PATH=${pkgs.cudaPackages.cudatoolkit}/lib:$LD_LIBRARY_PATH

              if [[ $- == *i* ]] && [ -z "$IN_NIX_SHELL_ZSH" ]; then
                export IN_NIX_SHELL_ZSH=1
                exec ${pkgs.zsh}/bin/zsh
              fi
            '';
          };

					# Webslop
					web = pkgs.mkShell {
            nativeBuildInputs = [
							pkgs.nodejs
							pkgs.pnpm
            ];

            shellHook = ''
              if [[ $- == *i* ]] && [ -z "$IN_NIX_SHELL_ZSH" ]; then
                export IN_NIX_SHELL_ZSH=1
                exec ${pkgs.zsh}/bin/zsh
              fi
            '';
          };

					# Go
					go = pkgs.mkShell {
            nativeBuildInputs = [
              pkgs.go
              pkgs.gopls
              pkgs.delve
              pkgs.go-tools
            ];

            shellHook = ''
              if [[ $- == *i* ]] && [ -z "$IN_NIX_SHELL_ZSH" ]; then
                export IN_NIX_SHELL_ZSH=1
                exec ${pkgs.zsh}/bin/zsh
              fi
            '';
          };	

					# Python
          python = pkgs.mkShell {
            nativeBuildInputs = [
							pkgs.python3
              pkgs.pyright
              pkgs.ruff
            ];

            shellHook = ''
							if [ ! -d ".venv" ]; then
                echo "Creating virtual environment..."
                ${pkgs.python3}/bin/python -m venv .venv
              fi

              source .venv/bin/activate

              if [[ $- == *i* ]] && [ -z "$IN_NIX_SHELL_ZSH" ]; then
                export IN_NIX_SHELL_ZSH=1
                exec ${pkgs.zsh}/bin/zsh
              fi
            '';
          };

					# Rust
          rust = pkgs.mkShell {
            nativeBuildInputs = [
              pkgs.cargo
              pkgs.rustc
              pkgs.rustfmt
              pkgs.clippy
              pkgs.rust-analyzer
            ];

            RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";

            shellHook = ''
              if [[ $- == *i* ]] && [ -z "$IN_NIX_SHELL_ZSH" ]; then
                export IN_NIX_SHELL_ZSH=1
                exec ${pkgs.zsh}/bin/zsh
              fi
            '';
          };

        };
      });
}
