{ config, lib, ... }:

let
  cfg = config.features.services.mounts;
in
{
  options.features.services.mounts.enable = lib.mkEnableOption "udisks2 and gvfs";

  config = lib.mkIf cfg.enable {
    services.udisks2.enable = true;

    services.gvfs.enable = true;
  };
}
