{ pkgs, mkShell }:

name:
mkShell name {
  packages = [
    pkgs.go
    pkgs.gopls
    pkgs.delve
    pkgs.go-tools
  ];
}
