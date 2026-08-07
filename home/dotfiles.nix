{ config, ... }:

let
  dotfilesDir = "/home/proteus/nix";

  link = name: config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/home/config/${name}";
in
{
  xdg.configFile = {
    "hypr".source = link "hypr";
    "kitty".source = link "kitty";
    "mpv".source = link "mpv";
    "btop".source = link "btop";
    "quickshell".source = link "quickshell";
    "nwg-look".source = link "nwg-look";
    "qt5ct".source = link "qt5ct";
    "qt6ct".source = link "qt6ct";
    "Kvantum".source = link "Kvantum";
    "gtk-3.0".source = link "gtk-3.0";
  };
}
