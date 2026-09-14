{ pkgs }:

let
  zshHook = ''
    if [[ $- == *i* ]] && [ -z "$IN_NIX_SHELL_ZSH" ]; then
      export IN_NIX_SHELL_ZSH=1
      exec ${pkgs.zsh}/bin/zsh
    fi
  '';
in
{
  cpp = import ./cpp.nix { inherit pkgs zshHook; };
  web = import ./web.nix { inherit pkgs zshHook; };
  go = import ./go.nix { inherit pkgs zshHook; };
  python = import ./python.nix { inherit pkgs zshHook; };
  rust = import ./rust.nix { inherit pkgs zshHook; };
  java = import ./java.nix { inherit pkgs zshHook; };
}
