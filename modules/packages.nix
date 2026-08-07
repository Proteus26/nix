{ pkgs, inputs, ... }:

{
  environment.systemPackages = with pkgs; [
    inputs.home-manager.packages.${pkgs.system}.default
    inputs.nh.packages.${pkgs.system}.default

    # Compilers and languages (build tools stay system-wide)
    gcc
    python3
    nodejs
    gnumake

    # System docs / tooling
    man
    man-pages
    man-pages-posix
    openssl
    glib
    zsh

    # Service-adjacent tools
    dconf
    udisks2
    gvfs

    # Qt theming (needs to be discoverable system-wide)
    libsForQt5.qt5ct
    kdePackages.qt6ct
    libsForQt5.qtstyleplugin-kvantum
    kdePackages.qtstyleplugin-kvantum
  ];
}
