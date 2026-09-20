{ config, lib, ... }:

let
  cfg = config.features.home.programs.kdeconnect;
in
{
  options.features.home.programs.kdeconnect.enable = lib.mkEnableOption "kdeconnect";

  config = lib.mkIf cfg.enable {
    services.kdeconnect = {
      enable = true;
      indicator = true;
    };
  };
}
