{ config, lib, ... }:

let
  cfg = config.features.filesystems.mounts;
in
{
  options.features.filesystems.mounts.enable = lib.mkEnableOption "filesystem mounts";

  config = lib.mkIf cfg.enable {
    fileSystems."/mnt/ssdihh" = {
      device = "/dev/disk/by-uuid/7548a1ed-3d14-4e48-b512-baa41300e8ec";
      fsType = "ext4";
      options = [
        "defaults"
        "nofail"
      ];
    };
  };
}
