{ pkgs, mkShell }:

name:
mkShell name {
  packages = [
    pkgs.nodejs_24
    pkgs.typescript
    pkgs.typescript-language-server
    pkgs.pkg-config
  ];
}
