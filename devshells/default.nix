# Per-language dev environments: `devshell <name>` (zsh function) or, per
# project, an .envrc containing `use flake ~/nix#<name>` (direnv is enabled).
{ pkgs }:

let
  # mkShell that records its name so the zsh prompt can show the active shell.
  mkShell =
    name: args:
    pkgs.mkShell (
      args
      // {
        inherit name;
        DEVSHELL_NAME = name;
      }
    );

  shells = [
    "cpp"
    "go"
    "java"
    "lean"
    "python"
    "rust"
    "web"
  ];
in
pkgs.lib.genAttrs shells (name: import ./${name}.nix { inherit pkgs mkShell; } name)
