{ config, lib, ... }:

let
  cfg = config.features.home.programs.btop;
in
{
  options.features.home.programs.btop.enable = lib.mkEnableOption "btop";

  config = lib.mkIf cfg.enable {
    programs.btop = {
      enable = true;

      # Keep the existing config verbatim; a placeholder setting is required
      # for home-manager to write btop.conf at all.
      settings = {
        theme_background = false;
      };

      extraConfig = builtins.readFile ../config/btop/btop.conf;
    };
  };
}
