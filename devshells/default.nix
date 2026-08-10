# Development shells. Imported by the main flake as `devShells = import ./devshells`.
{ pkgs }:

let
  # Exec into an interactive zsh when the shell is started from a terminal.
  zshHook = ''
    if [[ $- == *i* ]] && [ -z "$IN_NIX_SHELL_ZSH" ]; then
      export IN_NIX_SHELL_ZSH=1
      exec ${pkgs.zsh}/bin/zsh
    fi
  '';
in
{
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

    shellHook = zshHook;
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

      ${zshHook}
    '';
  };

  # Webslop
  web = pkgs.mkShell {
    nativeBuildInputs = [
      pkgs.nodejs_24
      pkgs.pnpm
      pkgs.typescript
      pkgs.typescript-language-server
      pkgs.pkg-config
    ];
    shellHook = zshHook;
  };

  # Go
  go = pkgs.mkShell {
    nativeBuildInputs = [
      pkgs.go
      pkgs.gopls
      pkgs.delve
      pkgs.go-tools
    ];

    shellHook = zshHook;
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

      ${zshHook}
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

    shellHook = zshHook;
  };

  # Chrono
  chrono = pkgs.mkShell {
    nativeBuildInputs = [
      pkgs.nodejs_24
      pkgs.pnpm
      pkgs.typescript
      pkgs.typescript-language-server
      pkgs.pkg-config
      pkgs.biome
      pkgs.postgresql
    ];
    shellHook = zshHook;
  };

  # Java
  java = pkgs.mkShell {
    nativeBuildInputs = [
      pkgs.jdk
      pkgs.maven
      pkgs.gradle
      pkgs.jdt-language-server
      pkgs.google-java-format
    ];

    shellHook = zshHook;
  };
}
