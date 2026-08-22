{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.features.hardware.wacom;
in
{
  options.features.hardware.wacom.enable = lib.mkEnableOption "Wacom tablet support";
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      libwacom
    ];
    services.udev.packages = [ pkgs.libwacom ];
  };
}
