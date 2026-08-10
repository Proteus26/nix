{ config, lib, ... }:

let
  cfg = config.features.home.programs.git;
in
{
  options.features.home.programs.git.enable = lib.mkEnableOption "git";

  config = lib.mkIf cfg.enable {
    programs.git = {
      enable = true;
      settings = {
        user = {
          name = "Proteus26";
          email = "lohithds52@gmail.com";
        };
      };
    };
  };
}
