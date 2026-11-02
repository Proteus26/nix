{ config, lib, ... }:

let
  cfg = config.features.programs.direnv;
in
{
  options.features.programs.direnv.enable = lib.mkEnableOption "direnv";

  config = lib.mkIf cfg.enable {
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
      direnvrcExtra = ''
        use_devshell() {
          local flake="''${NH_FLAKE:-$HOME/nix}"
          watch_file "$flake/flake.lock" "$flake"/devshells/*.nix
          if [ $# -eq 1 ]; then
            use flake "path:$flake#$1"
            return
          fi
          local file
          file="$(direnv_layout_dir)/devshell-$(IFS=+; echo "$*").nix"
          mkdir -p "$(dirname "$file")"
          printf '(builtins.getFlake "path:%s").lib.mergeDevShells [ %s]\n' \
            "$flake" "$(printf '"%s" ' "$@")" >"$file"
          use nix "$file"
        }
      '';
    };

    nix.settings.keep-outputs = true;
    nix.settings.keep-derivations = true;
  };
}
