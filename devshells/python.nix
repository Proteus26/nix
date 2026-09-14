{ pkgs, zshHook }:

pkgs.mkShell {
  packages = [
    pkgs.python3
    pkgs.pyright
    pkgs.ruff
    pkgs.uv
  ];

  shellHook = ''
    if [ -d ".venv" ]; then
      source .venv/bin/activate
    else
      echo "No .venv in \$PWD — create one with: uv venv .venv && source .venv/bin/activate"
    fi

    ${zshHook}
  '';
}
