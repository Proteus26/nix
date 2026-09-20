{ config, lib, ... }:

let
  cfg = config.features.home.programs.xdg;
in
{
  options.features.home.programs.xdg.enable = lib.mkEnableOption "xdg user dirs";

  config = lib.mkIf cfg.enable {
    xdg = {
      enable = true;
      userDirs = {
        enable = true;
        createDirectories = true;
        download = "${config.home.homeDirectory}/downloads";
      };
    };
  };
}
