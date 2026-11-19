{ config, lib, ... }:

let
  cfg = config.features.desktop.mango;
in
{
  options.features.desktop.mango.enable = lib.mkEnableOption "Mango compositor";

  config = lib.mkIf cfg.enable {
    # Also sets up the wlr/gtk portals and the session entry.
    programs.mango.enable = true;

    programs.uwsm = {
      enable = true;
      waylandCompositors.mango = {
        prettyName = "Mango";
        comment = "Mango compositor managed by UWSM";
        binPath = "/run/current-system/sw/bin/mango";
      };
    };

    features.desktop.portal.enable = true;
  };
}
