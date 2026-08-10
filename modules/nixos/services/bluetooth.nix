{ config, lib, ... }:

let
  cfg = config.features.services.bluetooth;
in
{
  options.features.services.bluetooth.enable = lib.mkEnableOption "bluetooth";

  config = lib.mkIf cfg.enable {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
    };

    boot.extraModprobeConfig = ''
      options bluetooth disable_ertm=Y
    '';

    services.blueman.enable = true;
  };
}
