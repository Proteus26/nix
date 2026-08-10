{ config, lib, ... }:

let
  cfg = config.features.home.files.dotfiles;

  dotfilesDir = "${config.home.homeDirectory}/nix/modules/home";

  # Symlink a config directory straight out of the repo so it stays
  # editable in place. Falls back to a store copy when the repo is not at
  # the expected path (e.g. when built as a pure home-manager config).
  link = name: config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/config/${name}";
in
{
  options.features.home.files.dotfiles.enable = lib.mkEnableOption "dotfiles";

  config = lib.mkIf cfg.enable {
    xdg.configFile = {
      "hypr".source = link "hypr";
      "kitty".source = link "kitty";
      "mpv".source = link "mpv";
      "btop".source = link "btop";
      "nwg-look".source = link "nwg-look";
      "qt5ct".source = link "qt5ct";
      "qt6ct".source = link "qt6ct";
      "Kvantum".source = link "Kvantum";
      "gtk-3.0".source = link "gtk-3.0";
      "quickshell".source = link "quickshell";
    };
  };
}
