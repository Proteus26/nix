{ config, lib, ... }:

let
  cfg = config.features.home.programs.hyprland;
in
{
  options.features.home.programs.hyprland.enable = lib.mkEnableOption "hyprland";

  config = lib.mkIf cfg.enable {
    # Only hyprland.lua is file-based (Lua config); hyprlock.conf and
    # hyprpaper.conf are rendered declaratively by their own modules.
    xdg.configFile."hypr/hyprland.lua".source = ../config/hypr/hyprland.lua;
  };
}
