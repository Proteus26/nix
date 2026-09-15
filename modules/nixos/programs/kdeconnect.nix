{ config, lib, ... }:

let
  cfg = config.features.programs.kdeconnect;
in
{
  options.features.programs.kdeconnect.enable = lib.mkEnableOption "kdeconnect";

  config = lib.mkIf cfg.enable {
    programs.kdeconnect.enable = true;
  };
}
