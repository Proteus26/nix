{ config, lib, ... }:

let
  cfg = config.features.virtualisation.docker;
in
{
  options.features.virtualisation.docker.enable = lib.mkEnableOption "docker";

  config = lib.mkIf cfg.enable {
    virtualisation.docker = {
      enable = true;
      enableOnBoot = true;

      rootless = {
        enable = false;
      };

      daemon.settings = {
        features = {
          buildkit = true;
        };
      };

      autoPrune = {
        enable = true;
        dates = "weekly";
      };
    };
  };
}
