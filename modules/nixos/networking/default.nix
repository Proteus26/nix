{ config, lib, ... }:

let
  cfg = config.features.networking;
in
{
  options.features.networking.enable = lib.mkEnableOption "networking (NetworkManager)";

  # Ports this host should accept inbound connections on (TCP and/or UDP).
  # Prefer opening ports in the module that needs them (see steam.nix);
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

  # NetworkManager hotspot ("shared" IPv4 mode). Instead of trusting the whole
  # Wi-Fi interface (which also trusts any network you join as a client), only
  # trust the hotspot's own subnet, and let clients reach NM's DHCP server.
  options.features.networking.hotspot = {
    enable = lib.mkEnableOption "firewall rules for a NetworkManager Wi-Fi hotspot";
    interface = lib.mkOption {
      type = lib.types.str;
      default = "wlo1";
      description = "Wi-Fi interface the hotspot runs on.";
    };
    subnet = lib.mkOption {
      type = lib.types.str;
      default = "10.42.0.0/24";
      description = "IPv4 subnet NetworkManager hands out to hotspot clients (NM default for shared mode).";
    };
  };

  config = lib.mkIf cfg.enable {
    networking.networkmanager.enable = true;

    networking.firewall.enable = true;

    # DHCP requests come from 0.0.0.0, so they can't be matched by subnet.
    networking.firewall.interfaces.${cfg.hotspot.interface}.allowedUDPPorts =
      lib.mkIf cfg.hotspot.enable
        [
          67
        ];
    # Everything else (DNS, LAN shares, ...) is accepted only from hotspot clients.
    networking.firewall.extraCommands = lib.mkIf cfg.hotspot.enable ''
      iptables -w -A nixos-fw -i ${cfg.hotspot.interface} -s ${cfg.hotspot.subnet} -j nixos-fw-accept
    '';

    networking.firewall.allowedTCPPorts = cfg.openPorts;
    networking.firewall.allowedUDPPorts = cfg.openPorts;
    networking.firewall.allowedTCPPortRanges = cfg.openPortRanges;
    networking.firewall.allowedUDPPortRanges = cfg.openPortRanges;
  };
}
