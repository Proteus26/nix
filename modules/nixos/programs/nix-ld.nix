{ config, lib, pkgs, ... }:

let
  cfg = config.features.programs.nix-ld;
in
{
  options.features.programs.nix-ld.enable = lib.mkEnableOption "nix-ld";

  config = lib.mkIf cfg.enable {
    programs.nix-ld.enable = true;
    programs.nix-ld.libraries = with pkgs; [ ];
  };
}
