{ config, lib, ... }:

let
  cfg = config.features.home.programs.mpv;
in
{
  options.features.home.programs.mpv.enable = lib.mkEnableOption "mpv";

  config = lib.mkIf cfg.enable {
    programs.mpv = {
      enable = true;

      config = {
        vo = "gpu-next";
        gpu-api = "vulkan";
        gpu-context = "waylandvk";

        hwdec = "auto-safe";

        profile = "high-quality";

        video-sync = "audio";
        interpolation = false;

        dither-depth = 8;
        dither = "fruit";
        video-output-levels = "auto";

        scale = "ewa_lanczos";
        cscale = "spline36";
        dscale = "mitchell";
        correct-downscaling = true;
        linear-downscaling = true;
        sigmoid-upscaling = true;

        scale-antiring = 0.7;
        cscale-antiring = 0.7;
        dscale-antiring = 0.7;

        deband = true;
        deband-iterations = 4;
        deband-threshold = 35;
        deband-range = 16;
        deband-grain = 4;

        tone-mapping = "bt.2446a";
        target-contrast = "auto";
        target-prim = "auto";
        target-trc = "auto";
        target-colorspace-hint = true;
        hdr-compute-peak = true;
        hdr-peak-percentile = 99.995;

        osd-font = "Inter";
        sub-font = "Inter";
        sub-font-size = 32;
        sub-bold = true;
        sub-italic = false;

        osd-on-seek = "msg";
        osd-bar = false;
        save-position-on-quit = true;
        keep-open = true;
        cursor-autohide = 1000;

        cache = true;
        demuxer-max-bytes = "500MiB";
        demuxer-max-back-bytes = "100MiB";
      };
    };
  };
}
