{ config, lib, ... }:

let
  cfg = config.features.home.programs.noctalia;
in
{
  options.features.home.programs.noctalia.enable = lib.mkEnableOption "noctalia shell";

  config = lib.mkIf cfg.enable {
    programs.noctalia = {
      enable = true;
      systemd.enable = true;

      settings = {
        theme = {
          mode = "dark";
          source = "builtin";
          builtin = "Catppuccin";
        };

        wallpaper = {
          enabled = true;
          default.path = "/home/proteus/pictures/mayforest.jpg";
        };
      };
    };
  };
}
