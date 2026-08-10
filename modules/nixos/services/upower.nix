{ config, lib, ... }:

let
  cfg = config.features.services.upower;
in
{
  options.features.services.upower.enable = lib.mkEnableOption "upower";

  config = lib.mkIf cfg.enable {
    services.upower.enable = true;
  };
}
