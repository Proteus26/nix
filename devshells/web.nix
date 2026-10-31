{ pkgs, zshHook }:

pkgs.mkShell {
  packages = [
    pkgs.nodejs_24
    pkgs.typescript
    pkgs.typescript-language-server
    pkgs.pkg-config
  ];

  shellHook = zshHook;
}
