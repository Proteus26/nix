# Dev environments: `devshell <name>...` (zsh function) or, per
# project, an .envrc containing `use devshell <name>...`.
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
        passthru.env = removeAttrs args [
          "packages"
          "shellHook"
        ];
      }
    );

  shells = {
    # example = {
    #   packages = [ pkgs.hello ];
    # };
  };
in
builtins.mapAttrs mkShell shells
