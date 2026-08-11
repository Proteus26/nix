{ config, lib, ... }:

let
  cfg = config.features.home.programs.quickshell;
in
{
  options.features.home.programs.quickshell.enable = lib.mkEnableOption "quickshell";

  config = lib.mkIf cfg.enable {
    programs.quickshell = {
      enable = true;
      # Config is maintained directly in ~/.config/quickshell/ (not via this repo),
      activeConfig = lib.mkDefault null;
      configs = lib.mkDefault { };
    };
  };
}
