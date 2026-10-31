{ config, lib, ... }:

let
  cfg = config.features.desktop.hyprland;
in
{
  options.features.desktop.hyprland.enable = lib.mkEnableOption "Hyprland compositor";

  config = lib.mkIf cfg.enable {
    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
      withUWSM = true;
    };

    # Hyprland needs the desktop portal (portal.nix is imported by ./default.nix).
    features.desktop.portal.enable = true;
  };
}
