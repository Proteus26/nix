{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.features.home.programs.guitar-fx;

  jackWrapped =
    name: pkg:
    pkgs.symlinkJoin {
      name = "${name}-jack";
      paths = [ pkg ];
      nativeBuildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        rm $out/bin/${name}
        makeWrapper ${pkg}/bin/${name} $out/bin/${name} \
          --prefix LD_LIBRARY_PATH : /run/current-system/sw/lib/pipewire
      '';
    };
in
{
  options.features.home.programs.guitar-fx.enable =
    lib.mkEnableOption "guitar FX rig (REAPER + yabridge + Wine)";

  config = lib.mkIf cfg.enable {
    home.packages = [
      (jackWrapped "reaper" pkgs.reaper)
      (jackWrapped "carla" pkgs.carla)
      pkgs.qpwgraph
      pkgs.yabridge
      pkgs.yabridgectl
      pkgs.wineWow64Packages.stable
    ];

    home.shellAliases.yasync = "yabridgectl sync";

    systemd.user.services.yabridge-sync = {
      Unit = {
        Description = "Sync yabridge plugin directories";
        After = [ "graphical-session.target" ];
      };
      Service = {
        Type = "oneshot";
        ExecStart = "${pkgs.yabridgectl}/bin/yabridgectl sync";
      };
      Install.WantedBy = [ "graphical-session.target" ];
    };
  };
}
