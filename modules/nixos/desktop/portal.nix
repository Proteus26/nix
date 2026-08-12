{ config, lib, pkgs, ... }:

let
  cfg = config.features.desktop.portal;
in
{
  options.features.desktop.portal.enable = lib.mkEnableOption "xdg desktop portal";

  config = lib.mkIf cfg.enable {
    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
      ];
      config = {
        common = {
          default = [
            "hyprland"
            "gtk"
          ];
        };
        hyprland = {
          default = [
            "hyprland"
            "gtk"
          ];
          "org.freedesktop.impl.portal.Settings" = [ "gtk" ];
        };
      };
    };

    systemd.user.services.xdg-desktop-portal = {
      unitConfig = lib.mkForce {
        Description = "Portal service";
        PartOf = lib.mkForce [ ];
        Requisite = lib.mkForce [ ];
        After = lib.mkForce [ ];
      };
    };
  };
}
