{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.features.desktop.sddm;

  backgroundImage = ../../home/assets/pictures/mayforest.jpg;

  sddmTheme = pkgs.stdenv.mkDerivation {
    pname = "sddm";
    version = "1.0.0";
    src = ./sddm/theme;
    inherit backgroundImage;
    dontBuild = true;
    installPhase = ''
      mkdir -p $out/share/sddm/themes/sddm
      cp -r $src/. $out/share/sddm/themes/sddm/
      cp $backgroundImage $out/share/sddm/themes/sddm/wallpaper.jpg
      substituteInPlace $out/share/sddm/themes/sddm/theme.conf \
        --replace "@BACKGROUND@" "$out/share/sddm/themes/sddm/wallpaper.jpg"
    '';
  };
in
{
  options.features.desktop.sddm.enable = lib.mkEnableOption "SDDM login manager";

  config = lib.mkIf cfg.enable {
    services.displayManager.sddm.enable = true;
    services.displayManager.sddm.wayland.enable = true;
    services.displayManager.defaultSession = "hyprland-uwsm";

    services.displayManager.sddm.theme = "sddm";
    services.displayManager.sddm.extraPackages = [ sddmTheme ];

    environment.systemPackages = [ sddmTheme ];
  };
}
