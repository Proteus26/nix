{ config, lib, ... }:

let
  cfg = config.features.home.files.dotfiles;
in
{
  options.features.home.files.dotfiles.enable = lib.mkEnableOption "dotfiles";

  config = lib.mkIf cfg.enable {
    xdg.configFile = {
      "nwg-look".source = ../config/nwg-look;
      "qt5ct".source = ../config/qt5ct;
      "qt6ct".source = ../config/qt6ct;
      "Kvantum".source = ../config/Kvantum;
    };
  };
}
