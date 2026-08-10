{ config, lib, pkgs, ... }:

let
  cfg = config.features.home.files.assets;

  # Catppuccin Mocha, mauve accent (matches the vendored theme this replaced).
  catppuccinGtk = pkgs.catppuccin-gtk.override {
    variant = "mocha";
    accents = [ "mauve" ];
    size = "standard";
  };

  gtkThemeName = "catppuccin-mocha-mauve-standard";

  # Open-source macOS cursors.
  appleCursor = pkgs.apple-cursor;
  cursorThemeName = "macOS";
in
{
  options.features.home.files.assets.enable = lib.mkEnableOption "assets";

  config = lib.mkIf cfg.enable {
    home.file = {
      ".themes/${gtkThemeName}" = {
        source = "${catppuccinGtk}/share/themes/${gtkThemeName}";
        recursive = true;
      };
      ".icons/${cursorThemeName}" = {
        source = "${appleCursor}/share/icons/${cursorThemeName}";
        recursive = true;
      };
      "pictures/mayforest.jpg" = {
        source = ./../assets/pictures/mayforest.jpg;
      };
    };
  };
}
