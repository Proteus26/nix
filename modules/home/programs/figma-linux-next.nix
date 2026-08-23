{ config, lib, pkgs, inputs, ... }:

let
  cfg = config.features.home.programs.figma-linux-next;
in
{
  options.features.home.programs.figma-linux-next.enable = lib.mkEnableOption "Figma Linux Next";

  config = lib.mkIf cfg.enable {
    home.packages = [
      inputs.figma-linux-next.packages.${pkgs.system}.default
    ];
  };
}
