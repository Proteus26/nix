{ config, lib, ... }:

let
  cfg = config.features.home.programs.noctalia;
in
{
  options.features.home.programs.noctalia.enable = lib.mkEnableOption "noctalia shell";

  config = lib.mkIf cfg.enable {
    programs.noctalia = {
      enable = true;
      # Started by exec_cmd("noctalia") in ~/.config/hypr/hyprland.lua; a systemd
      # unit as well would just fail with "noctalia is already running".
      systemd.enable = false;

      settings = {
        theme = {
          mode = "dark";
          source = "builtin";
          builtin = "Catppuccin";
        };

        wallpaper = {
          enabled = true;
          default.path = "${config.home.homeDirectory}/pictures/mayforest.jpg";
        };
      };
    };
  };
}
