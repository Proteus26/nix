{ config, lib, ... }:

let
  cfg = config.features.environment.env;
in
{
  options.features.environment.env.enable = lib.mkEnableOption "session environment variables";

  config = lib.mkIf cfg.enable {
    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
      XDG_SESSION_TYPE = "wayland";
      AQ_DRM_DEVICES = "/dev/dri/intel-igpu:/dev/dri/nvidia-dgpu";
      MOZ_DRM_DEVICE = "/dev/dri/intel-igpu";
      FREETYPE_PROPERTIES = "cff:no-stem-darkening=0 autofitter:no-stem-darkening=0";
    };
  };
}
