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
      jack.enable = true;

      extraConfig.pipewire."99-audio-prod"."context.properties" = {
        "default.clock.rate" = 48000;
        "default.clock.quantum" = 128;
        "default.clock.min-quantum" = 32;
      };
    };

    security.rtkit.enable = true;
    security.pam.loginLimits = [
      {
        domain = "@audio";
        item = "memlock";
        type = "-";
        value = "unlimited";
      }
      {
        domain = "@audio";
        item = "rtprio";
        type = "-";
        value = "98";
      }
    ];
  };
}
