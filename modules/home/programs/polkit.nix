{ config, lib, ... }:

let
  cfg = config.features.home.programs.polkit;
in
{
  options.features.home.programs.polkit.enable = lib.mkEnableOption "polkit authentication agent";

  config = lib.mkIf cfg.enable {
    services.polkit-gnome.enable = true;
  };
}
