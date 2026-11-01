{ config, lib, ... }:

let
  cfg = config.features.home.programs.gh;
in
{
  options.features.home.programs.gh.enable = lib.mkEnableOption "GitHub CLI";

  config = lib.mkIf cfg.enable {
    programs.gh = {
      enable = true;
      settings.git_protocol = "ssh";
    };
  };
}
