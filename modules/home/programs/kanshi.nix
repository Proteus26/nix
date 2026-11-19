{ config, lib, ... }:

let
  cfg = config.features.home.programs.kanshi;
in
{
  options.features.home.programs.kanshi.enable = lib.mkEnableOption "kanshi output profiles";

  config = lib.mkIf cfg.enable {
    services.kanshi = {
      enable = true;
      systemdTarget = "graphical-session.target";
      settings = [
        {
          profile.name = "docked";
          profile.outputs = [
            {
              criteria = "DP-1";
              mode = "2560x1440@180Hz";
              position = "0,0";
              scale = 1.0;
            }
            {
              criteria = "eDP-1";
              status = "disable";
            }
          ];
        }
        {
          profile.name = "hdmi";
          profile.outputs = [
            {
              criteria = "HDMI-A-1";
              position = "0,0";
              scale = 1.0;
            }
            {
              criteria = "eDP-1";
              status = "disable";
            }
          ];
        }
        {
          profile.name = "laptop";
          profile.outputs = [
            {
              criteria = "eDP-1";
              status = "enable";
              scale = 1.0;
            }
          ];
        }
      ];
    };
  };
}
