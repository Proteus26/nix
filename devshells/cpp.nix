{ pkgs, mkShell }:

name:
mkShell name {
  packages = [
    pkgs.gcc
    pkgs.gnumake
    pkgs.cmake
    pkgs.ninja
    pkgs.pkg-config
    pkgs.clang-tools
    pkgs.bear
    pkgs.gdb
    pkgs.gtest
  ];

  # Lets clangd find the glibc headers in files without a compile_commands.json.
  CPATH = pkgs.lib.makeSearchPathOutput "dev" "include" [ pkgs.glibc ];

  CMAKE_EXPORT_COMPILE_COMMANDS = "1";
}
