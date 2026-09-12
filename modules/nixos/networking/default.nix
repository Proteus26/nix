{ config, lib, ... }:

let
  cfg = config.features.networking;
in
{
  options.features.networking.enable = lib.mkEnableOption "networking (NetworkManager)";

  # Ports this host should accept inbound connections on (TCP and/or UDP).
  # Prefer opening ports in the module that needs them (see ssh.nix);
  # use these only for ports with no clear owner module.
  options.features.networking.openPorts = lib.mkOption {
    type = lib.types.listOf lib.types.port;
    default = [ ];
    description = "TCP/UDP ports to open in the firewall so clients can connect to them.";
  };

  # Port ranges this host should accept inbound connections on (TCP and/or UDP).
  options.features.networking.openPortRanges = lib.mkOption {
    type = lib.types.listOf (
      lib.types.submodule {
        options = {
          from = lib.mkOption {
            type = lib.types.port;
            description = "First port in the range.";
          };
          to = lib.mkOption {
            type = lib.types.port;
            description = "Last port in the range.";
          };
        };
      }
    );
    default = [ ];
    description = "TCP/UDP port ranges to open in the firewall so clients can connect to them.";
  };

  config = lib.mkIf cfg.enable {
    networking.networkmanager.enable = true;

    networking.firewall.enable = true;
    networking.firewall.allowedTCPPorts = cfg.openPorts;
    networking.firewall.allowedUDPPorts = cfg.openPorts;
    networking.firewall.allowedTCPPortRanges = cfg.openPortRanges;
    networking.firewall.allowedUDPPortRanges = cfg.openPortRanges;
  };
}
