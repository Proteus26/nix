{ config, lib, ... }:

let
  cfg = config.features.hardware.keyboards;
in
{
  options.features.hardware.keyboards.enable = lib.mkEnableOption "WebHID access";

  config = lib.mkIf cfg.enable {
    services.udev.extraRules = ''
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="3151", MODE="0660", GROUP="users", TAG+="uaccess"
    '';
  };
}
