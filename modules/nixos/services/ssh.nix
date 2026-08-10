{ config, lib, ... }:

let
  cfg = config.features.services.ssh;
in
{
  options.features.services.ssh.enable = lib.mkEnableOption "ssh (openssh)";

  config = lib.mkIf cfg.enable {
    services.openssh.enable = true;
  };
}
