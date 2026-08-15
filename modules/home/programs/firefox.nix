{ config, lib, pkgs, ... }:

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
          "gfx.webrender.software" = true;

          "media.ffmpeg.vaapi.enabled" = true;
          "media.hardware-video-decoding.enabled" = true;
          "media.mediacapabilities.hardware" = true;

          "font.default" = "sans-serif";
          "font.name.sans-serif.x-western" = "";
          "font.name.serif.x-western" = "";
          "font.name.monospace.x-western" = "";
        };
      };
    };
  };
}
