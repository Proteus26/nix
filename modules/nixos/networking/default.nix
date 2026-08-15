{ config, lib, ... }:

let
  cfg = config.features.networking;
in
{
  options.features.networking.enable = lib.mkEnableOption "networking (NetworkManager)";

  # Ports this host should accept inbound connections on (TCP and/or UDP).
  options.features.networking.openPorts = lib.mkOption {
    type = lib.types.listOf lib.types.port;
    default = [ ];
    description = "TCP/UDP ports to open in the firewall so clients can connect to them.";
  };

  config = lib.mkIf cfg.enable {
    networking.networkmanager.enable = true;

    networking.firewall.enable = true;
    networking.firewall.allowedTCPPorts = cfg.openPorts;
    networking.firewall.allowedUDPPorts = cfg.openPorts;
  };
}
