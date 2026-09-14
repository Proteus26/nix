{ pkgs, zshHook }:

pkgs.mkShell {
  packages = [
    pkgs.rustup
    pkgs.rust-analyzer
    pkgs.gcc
    pkgs.pkg-config
    pkgs.openssl
  ];

  shellHook = ''
    if ! rustup toolchain list 2>/dev/null | grep -q .; then
      echo "No rustup toolchain installed — run: rustup toolchain install stable --profile minimal --component rust-src"
    fi

    ${zshHook}
  '';
}
