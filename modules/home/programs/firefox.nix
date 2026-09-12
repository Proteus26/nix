{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.features.home.programs.firefox;
in
{
  options.features.home.programs.firefox.enable = lib.mkEnableOption "firefox";

  config = lib.mkIf cfg.enable {
    programs.firefox = {
      enable = true;

      profiles.proteus = {
        id = 0;
        isDefault = true;
        name = "default";
        path = "ej87vux4.default";

        settings = {
          "gfx.webrender.all" = true;
          "layers.acceleration.force-enabled" = true;

          "media.ffmpeg.vaapi.enabled" = false;
          "media.hardware-video-decoding.enabled" = false;
          "media.mediacapabilities.hardware" = false;

          "font.default" = "sans-serif";
          "font.name.sans-serif.x-western" = "";
          "font.name.serif.x-western" = "";
          "font.name.monospace.x-western" = "";
        };
      };
    };
  };
}
