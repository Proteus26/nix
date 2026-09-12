{ config, lib, pkgs, inputs, ... }:

let
  cfg = config.features.environment.packages;
in
{
  options.features.environment.packages.enable = lib.mkEnableOption "system packages";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      inputs.nh.packages.${pkgs.stdenv.hostPlatform.system}.default

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

      # Service-adjacent tools
      dconf
      gsettings-desktop-schemas
      udisks2
      gvfs
    ];
  };
}
