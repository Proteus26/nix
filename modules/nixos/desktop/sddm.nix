{ config, lib, ... }:

let
  cfg = config.features.desktop.sddm;
in
{
  options.features.desktop.sddm.enable = lib.mkEnableOption "SDDM login manager";

  config = lib.mkIf cfg.enable {
    services.displayManager.sddm.enable = true;
    services.displayManager.sddm.wayland.enable = true;
    services.displayManager.defaultSession = "hyprland-uwsm";
  };
}
