{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.features.home.programs.mpv;
in
{
  options.features.home.programs.mpv.enable = lib.mkEnableOption "mpv";
  config = lib.mkIf cfg.enable {
    programs.mpv = {
      enable = true;

      scripts = with pkgs.mpvScripts; [
        uosc
        mpris
        thumbnail
      ];

      config = {
        # Output
        vo = "gpu-next";
        gpu-api = "vulkan";
        gpu-context = "waylandvk";
        hwdec = "auto-safe";
        vulkan-async-transfer = true;
        vulkan-async-compute = true;

        profile = "high-quality";
        video-sync = "audio";
        video-output-levels = "auto";

        # Scaling
        scale = "ewa_lanczos";
        cscale = "spline36";
        dscale = "mitchell";
        scale-antiring = 0.7;
        cscale-antiring = 0.7;
        dscale-antiring = 0.7;

        # Debanding
        deband = true;
        deband-iterations = 4;
        deband-threshold = 35;
        deband-range = 16;
        deband-grain = 4;

        # Dithering
        dither = "fruit";

        # HDR
        tone-mapping = "bt.2446a";
        target-contrast = "auto";
        target-prim = "auto";
        target-trc = "auto";
        target-colorspace-hint = true;
        hdr-compute-peak = true;
        hdr-peak-percentile = 99.995;

        # Subs
        osd-font = "Inter";
        sub-font = "Inter";
        sub-font-size = 32;
        sub-bold = true;
        sub-italic = false;
        osd-on-seek = "msg";
        osd-bar = false;

        # Screenshots
        screenshot-format = "png";
        screenshot-template = "~/Pictures/mpv-screenshots/%F_%p";
        screenshot-high-bit-depth = true;

        #  Misc
        save-position-on-quit = true;
        keep-open = true;
        cursor-autohide = 1000;
        border = false;
        watch-later-directory = "~/.cache/mpv/watch_later";

        # Cachig
        cache = true;
        demuxer-max-bytes = "500MiB";
        demuxer-max-back-bytes = "100MiB";
      };
    };
  };
}
