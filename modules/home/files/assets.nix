{ config, lib, ... }:

let
  cfg = config.features.home.files.assets;
in
{
  options.features.home.files.assets.enable = lib.mkEnableOption "assets";

  # GTK theme and cursor are installed by gtk.nix via their `package` options.
  config = lib.mkIf cfg.enable {
    home.file."pictures/mayforest.jpg".source = ../assets/pictures/mayforest.jpg;
  };
}
