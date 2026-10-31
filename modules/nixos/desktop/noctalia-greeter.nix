{
  config,
  lib,
  pkgs,
  hostspec,
  ...
}:

let
  cfg = config.features.desktop.noctalia-greeter;
in
{
  options.features.desktop.noctalia-greeter.enable =
    lib.mkEnableOption "Noctalia Greeter (greetd login screen matching the Noctalia shell)";

  config = lib.mkIf cfg.enable {
    services.displayManager.noctalia-greeter = {
      enable = true;

      # Lets Noctalia (Settings → Security → Noctalia Greeter) push its
      # wallpaper/palette/font to the greeter without a password prompt.
      # The polkit rule is limited to the packaged appearance helper.
      passwordlessSyncUsers = [ hostspec.username ];

      cursorTheme = {
        package = pkgs.apple-cursor;
        name = "macOS";
      };

      # Written to /var/lib/noctalia-greeter/greeter.toml; wins over Sync.
      settings = {
        session.default = "Hyprland (uwsm-managed)";
        user.default = hostspec.username;
        cursor.size = 24;
        keyboard = {
          inherit (config.services.xserver.xkb) layout variant;
          numlock = true;
        };
        # Used until the first Sync from Noctalia replaces it.
        appearance.wallpaper = {
          path = "${../../home/assets/pictures/mayforest.jpg}";
          fill_mode = "crop";
        };
      };
    };
  };
}
