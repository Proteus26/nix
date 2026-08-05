{ ... }:

{
  xdg.configFile = {
    "hypr" = { source = ./config/hypr; recursive = true; };
    "kitty" = { source = ./config/kitty; recursive = true; };
    "mpv" = { source = ./config/mpv; recursive = true; };
    "btop" = { source = ./config/btop; recursive = true; };
    "quickshell" = { source = ./config/quickshell; recursive = true; };
    "nwg-look" = { source = ./config/nwg-look; recursive = true; };
    "qt5ct" = { source = ./config/qt5ct; recursive = true; };
    "qt6ct" = { source = ./config/qt6ct; recursive = true; };
    "Kvantum" = { source = ./config/Kvantum; recursive = true; };
    "gtk-3.0" = { source = ./config/gtk-3.0; recursive = true; };
  };
}
