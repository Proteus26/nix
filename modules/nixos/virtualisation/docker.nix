{ config, lib, ... }:

let
  cfg = config.features.virtualisation.docker;
in
{
  options.features.virtualisation.docker.enable = lib.mkEnableOption "docker";

  config = lib.mkIf cfg.enable {
    virtualisation.docker = {
      enable = true;
      enableOnBoot = true;

      rootless = {
        enable = false;
      };

      daemon.settings = {
        features = {
          buildkit = true;
        };

        mtu = 1380;
        default-network-opts.bridge."com.docker.network.driver.mtu" = "1380";
      };

      autoPrune = {
        enable = true;
        dates = "weekly";
      };
    };

    networking.firewall.extraCommands = ''
      iptables -w -t mangle -A FORWARD -o wg0 -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu
    '';
    networking.firewall.extraStopCommands = ''
      iptables -w -t mangle -D FORWARD -o wg0 -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu || true
    '';
  };
}
