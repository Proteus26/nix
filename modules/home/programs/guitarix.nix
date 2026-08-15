{ config, lib, pkgs, ... }:

let
  cfg = config.features.home.programs.guitarix;

  pwlink = "${pkgs.pipewire}/bin/pw-link";

  launcher = pkgs.writeShellScriptBin "guitarix" ''
    export LD_LIBRARY_PATH="${pkgs.pipewire.jack}/lib''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"

    # Launch guitarix with jack routed through PipeWire.
    ${lib.getExe pkgs.guitarix} "$@" &
    GX_PID=$!

    # Wait for guitarix's JACK ports to appear, then patch the graph so the
    # guitar interface feeds in and the amped output reaches the headphones.
    for _ in $(seq 1 50); do
      if ${pwlink} -l 2>/dev/null | grep -q "gx_head:out_L"; then
        USBCAP=$( ${pwlink} -o 2>/dev/null \
          | grep "alsa_input.usb-Burr-Brown_from_TI_USB_Audio_CODEC-00.*capture" || true )
        FORTH=$( ${pwlink} -i 2>/dev/null \
          | grep "gx_head:in_.*" || true )
        GXOUT=$( ${pwlink} -o 2>/dev/null \
          | grep "gx_head:out_.*" || true )
        HEADP=$( ${pwlink} -i 2>/dev/null \
          | grep "alsa_output.usb-Burr-Brown_from_TI_USB_Audio_CODEC-00.*playback" || true )

        # Guitar interface -> guitarix input
        for p in $USBCAP; do
          for q in $FORTH; do
            ${pwlink} "$p" "$q" 2>/dev/null
          done
        done
        # guitarix output -> headphones
        for p in $GXOUT; do
          for q in $HEADP; do
            ${pwlink} "$p" "$q" 2>/dev/null
          done
        done
        break
      fi
      sleep 0.2
    done

    wait $GX_PID
  '';
in
{
  options.features.home.programs.guitarix.enable = lib.mkEnableOption "guitarix";

  config = lib.mkIf cfg.enable {
    home.packages = [ launcher ];
  };
}