{ config, lib, ... }:

let
  cfg = config.features.home.programs.hyprpaper;
in
{
  options.features.home.programs.hyprpaper.enable = lib.mkEnableOption "hyprpaper";

  config = lib.mkIf cfg.enable {
    services.hyprpaper = {
      enable = true;
      # hyprpaper is already installed and started by hyprland.lua, so keep the
      # module from also starting a systemd user service.
      package = null;
      settings = {
        splash = false;

        wallpaper = [
          {
            monitor = "";
            path = "/home/proteus/pictures/mayforest.jpg";
            fit_mode = "cover";
          }
        ];
      };
    };
  };
}
