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
    };
  };
}
