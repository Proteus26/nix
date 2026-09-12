{ config, lib, ... }:

let
  cfg = config.features.environment.qt;
in
{
  options.features.environment.qt.enable = lib.mkEnableOption "Qt theming (qt5ct/qt6ct + Kvantum)";

  config = lib.mkIf cfg.enable {
    qt = {
      enable = true;
      platformTheme = "qt5ct";
      style = "kvantum";
    };
  };
}
