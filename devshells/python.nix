{ pkgs, mkShell }:

name:
mkShell name {
  packages = [
    pkgs.python3
    pkgs.pyright
    pkgs.ruff
    pkgs.uv
  ];

  # Binary wheels (numpy, torch, ...) load their native libs through nix-ld,
  # which is enabled system-wide.
  shellHook = ''
    if [ -f .venv/bin/activate ]; then
      source .venv/bin/activate
    else
      echo "No .venv in $PWD — create one with: uv venv"
    fi
  '';
}
