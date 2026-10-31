{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.features.home.programs.gtk;

  # Catppuccin Mocha, mauve accent.
  catppuccinGtk = pkgs.catppuccin-gtk.override {
    variant = "mocha";
    accents = [ "mauve" ];
    size = "standard";
  };

  cursor = {
    name = "macOS";
    package = pkgs.apple-cursor;
    size = 24;
  };
in
{
  options.features.home.programs.gtk.enable = lib.mkEnableOption "gtk";

  config = lib.mkIf cfg.enable {
    dconf.settings."org.gnome.desktop.interface".color-scheme = "prefer-dark";

    # Sets XCURSOR_*, gtk.cursorTheme and ~/.icons/default so GTK, Qt and XWayland agree.
    home.pointerCursor = cursor // {
      enable = true;
      gtk.enable = true;
      x11.enable = true;
    };

    gtk = {
      enable = true;

      theme = {
        name = "catppuccin-mocha-mauve-standard";
        package = catppuccinGtk;
      };

      iconTheme = {
        name = "Adwaita";
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
