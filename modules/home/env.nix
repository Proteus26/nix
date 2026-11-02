{ config, lib, ... }:

let
  cfg = config.features.home.env;
in
{
  options.features.home.env.enable = lib.mkEnableOption "user session environment variables";

  config = lib.mkIf cfg.enable {
    home.sessionVariables = {
      EDITOR = "nvim";
      CMAKE_EXPORT_COMPILE_COMMANDS = "1";
    };
  };
}
