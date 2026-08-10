{ config, lib, ... }:

let
  cfg = config.features.networking;
in
{
  options.features.networking.enable = lib.mkEnableOption "networking (NetworkManager)";

  config = lib.mkIf cfg.enable {
    networking.networkmanager.enable = true;
  };
}
