# Go.
{ pkgs, zshHook }:

pkgs.mkShell {
  packages = [
    pkgs.go
    pkgs.gopls
    pkgs.delve
    pkgs.go-tools
  ];

  shellHook = zshHook;
}
