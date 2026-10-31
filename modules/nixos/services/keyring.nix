{ config, lib, ... }:

let
  cfg = config.features.services.keyring;
in
{
  options.features.services.keyring.enable =
    lib.mkEnableOption "GNOME Keyring (Secret Service + SSH agent), unlocked at login";

  config = lib.mkIf cfg.enable {
    services.gnome.gnome-keyring.enable = true;
  };
}
