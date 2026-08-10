{ config, lib, ... }:

let
  cfg = config.features.services.printing;
in
{
  options.features.services.printing.enable = lib.mkEnableOption "printing";

  config = lib.mkIf cfg.enable {
    services.printing.enable = true;
  };
}
