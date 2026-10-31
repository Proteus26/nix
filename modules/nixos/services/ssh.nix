{ config, lib, ... }:

let
  cfg = config.features.services.ssh;
in
{
  options.features.services.ssh.enable = lib.mkEnableOption "ssh (openssh)";

  config = lib.mkIf cfg.enable {
    # Port 22 is opened by services.openssh.openFirewall (default true).
    services.openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "no";
      };
    };
  };
}
