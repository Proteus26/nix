{ config, lib, ... }:

let
  cfg = config.features.home.programs.hyprland;
in
{
  options.features.home.programs.hyprland.enable = lib.mkEnableOption "hyprland";

  config = lib.mkIf cfg.enable {
    # hyprland.lua is maintained directly in ~/.config/hypr/ (not via this repo).
  };
}
