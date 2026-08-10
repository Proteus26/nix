{ config, lib, ... }:

let
  cfg = config.features.services.audio;
in
{
  options.features.services.audio.enable = lib.mkEnableOption "audio (PipeWire)";

  config = lib.mkIf cfg.enable {
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    security.rtkit.enable = true;
  };
}
