{ config, lib, ... }:

let
  cfg = config.features.home.programs.t3code;
in
{
  options.features.home.programs.t3code.enable =
    lib.mkEnableOption "T3 Code (official AppImage in ~/applications)";

  config = lib.mkIf cfg.enable {
    xdg.desktopEntries.t3code = {
      name = "T3 Code";
      comment = "Minimal web GUI for coding agents";
      exec = "${config.home.homeDirectory}/applications/T3-Code.AppImage %U";
      icon = "com.t3tools.T3Code";
      categories = [ "Development" ];
      terminal = false;
      settings.StartupWMClass = "com.t3tools.T3Code";
    };
  };
}
