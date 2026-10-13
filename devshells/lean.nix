{ pkgs, zshHook }:

pkgs.mkShell {
  packages = [
    pkgs.elan
  ];

  shellHook = ''
    if ! elan toolchain list 2>/dev/null | grep -q .; then
      echo "No Lean toolchain installed — run: elan toolchain install stable"
      echo "Then in a project dir: lake init <name> (writes lean-toolchain file)"
    fi

    ${zshHook}
  '';
}
