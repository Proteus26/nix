{ config, lib, ... }:

let
  cfg = config.features.programs.dconf;
in
{
  options.features.programs.dconf.enable = lib.mkEnableOption "dconf";

  config = lib.mkIf cfg.enable {
    programs.dconf.enable = true;
  };
}
