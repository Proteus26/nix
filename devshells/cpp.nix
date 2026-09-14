{ pkgs, zshHook }:

pkgs.mkShell {
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

  CPATH = builtins.toString (
    pkgs.lib.makeSearchPathOutput "dev" "include" [
      pkgs.glibc.dev
      pkgs.gcc.cc
    ]
  );

  CMAKE_EXPORT_COMPILE_COMMANDS = "1";

  shellHook = zshHook;
}
