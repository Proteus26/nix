{ config, lib, ... }:

let
  cfg = config.features.programs.appimage;
in
{
  options.features.programs.appimage.enable = lib.mkEnableOption "appimage support";

  config = lib.mkIf cfg.enable {
    programs.appimage = {
      enable = true;
      binfmt = true;
    };
  };
}
