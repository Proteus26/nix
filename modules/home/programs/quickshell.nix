{ config, lib, ... }:

let
  cfg = config.features.home.programs.quickshell;
in
{
  options.features.home.programs.quickshell.enable = lib.mkEnableOption "quickshell";

  config = lib.mkIf cfg.enable {
    programs.quickshell = {
      enable = true;
      activeConfig = "main";
      configs = {
        main = ../config/quickshell;
      };
    };
  };
}
