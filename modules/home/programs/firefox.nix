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
          "browser.download.dir" = "${config.home.homeDirectory}/downloads";
          "browser.download.folderList" = 2;
          "browser.download.useDownloadDir" = true;

          "media.hardware-video-decoding.force-enabled" = true;
        };
      };
    };
  };
}
