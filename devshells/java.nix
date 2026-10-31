{ pkgs, mkShell }:

name:
mkShell name {
  packages = [
    pkgs.jdk21
    pkgs.maven
    pkgs.gradle
    pkgs.jdt-language-server
    pkgs.google-java-format
  ];

  JAVA_HOME = "${pkgs.jdk21}/lib/openjdk";
}
