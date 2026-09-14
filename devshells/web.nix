{ pkgs, zshHook }:

pkgs.mkShell {
  packages = [
    pkgs.nodejs_24
    pkgs.pnpm
    pkgs.typescript
    pkgs.typescript-language-server
    pkgs.pkg-config
  ];

  shellHook = zshHook;
}
