{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.features.home.programs.vivaldi;
in
{
  options.features.home.programs.vivaldi.enable = lib.mkEnableOption "Vivaldi browser";

  config = lib.mkIf cfg.enable {
    programs.vivaldi = {
      enable = true;
      package = pkgs.vivaldi.override {
        proprietaryCodecs = true;
        enableWidevine = true;
      };
      commandLineArgs = [
        "--ozone-platform-hint=auto"
        "--enable-wayland-ime"
      ];
    };
  };
}
