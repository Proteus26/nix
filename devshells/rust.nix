{ pkgs, mkShell }:

name:
mkShell name {
  # rustup ships proxies for cargo/rustc/rust-analyzer/clippy/rustfmt that
  # dispatch to the active toolchain, so rust-analyzer always matches rustc.
  packages = [
    pkgs.rustup
    pkgs.pkg-config
    pkgs.openssl
  ];

  shellHook = ''
    if ! rustup toolchain list 2>/dev/null | grep -qv 'no installed toolchains'; then
      echo "No rustup toolchain installed — run: rustup toolchain install stable --profile minimal"
    fi
    if ! rustup component list --installed 2>/dev/null | grep -q '^rust-analyzer'; then
      echo "For editor support run: rustup component add rust-analyzer rust-src clippy rustfmt"
    fi
  '';
}
