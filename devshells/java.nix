{ pkgs, zshHook }:

pkgs.mkShell {
  packages = [
    pkgs.jdk21
    pkgs.maven
    pkgs.gradle
    pkgs.jdt-language-server
    pkgs.google-java-format
  ];

  shellHook = zshHook;
}
