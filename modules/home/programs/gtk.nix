{ config, lib, ... }:

let
  cfg = config.features.home.programs.gtk;
in
{
  options.features.home.programs.gtk.enable = lib.mkEnableOption "gtk";

  config = lib.mkIf cfg.enable {
    dconf.settings."org.gnome.desktop.interface".color-scheme = "prefer-dark";

    gtk = {
      enable = true;

      theme = {
        name = "catppuccin-mocha-mauve-standard";
      };

      iconTheme = {
        name = "Adwaita";
      };

      cursorTheme = {
        name = "macOS";
        size = 24;
      };

      font = {
        name = "Adwaita Sans";
        size = 11;
      };

      gtk4.extraConfig = {
        gtk-application-prefer-dark-theme = "1";
      };

      gtk3.extraConfig = {
        gtk-toolbar-style = "GTK_TOOLBAR_ICONS";
        gtk-toolbar-icon-size = "GTK_ICON_SIZE_LARGE_TOOLBAR";
        gtk-button-images = "0";
        gtk-menu-images = "0";
        gtk-enable-event-sounds = "1";
        gtk-enable-input-feedback-sounds = "0";
        gtk-xft-antialias = "1";
        gtk-xft-hinting = "1";
        gtk-xft-hintstyle = "hintslight";
        gtk-xft-rgba = "rgb";
        gtk-application-prefer-dark-theme = "1";
      };
    };
  };
}
