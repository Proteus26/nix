{ config, lib, ... }:

let
  cfg = config.features.home.programs.quickshell;
in
{
  options.features.home.programs.quickshell.enable = lib.mkEnableOption "quickshell";

  config = lib.mkIf cfg.enable {
    programs.quickshell = {
      enable = true;
      # Config is served as the *default* layout so the instance is discoverable
      # via IPC (`qs ipc call <target> ...`) without `-c`. home-manager's
      # `configs.<name>` option would nest it under `quickshell/<name>/`,
      # which quickshell registers as a named config and can't be reached by
      # an unqualified IPC call. Symlinking the whole dir to the top level
      # makes `~/.config/quickshell/shell.qml` exist -> 'default' config.
      activeConfig = lib.mkDefault null;
      configs = lib.mkDefault { };
    };

    xdg.configFile."quickshell".source = ../config/quickshell;
  };
}