{ config, lib, ... }:

let
  cfg = config.features.desktop.hyprland;
in
{
  imports = [
    # Hyprland needs the desktop portal; pulling it here keeps the
    # dependency declared by the feature itself (dendritic).
    ./portal.nix
  ];

  options.features.desktop.hyprland.enable = lib.mkEnableOption "Hyprland compositor";

  config = lib.mkIf cfg.enable {
    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
    };

    features.desktop.portal.enable = true;
  };
}
