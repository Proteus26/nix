{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.features.home.programs.java;
in
{
  options.features.home.programs.java.enable = lib.mkEnableOption "Java (JDK and JAVA_HOME)";

  config = lib.mkIf cfg.enable {
    programs.java = {
      enable = true;
      package = pkgs.jdk21;
    };
  };
}
