{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.features.environment.packages;
in
{
  options.features.environment.packages.enable = lib.mkEnableOption "system packages";

  # nh comes from programs.nh (core/nix.nix); dconf, udisks2, gvfs and
  # gsettings schemas come from the services/programs that enable them.
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
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
    ];
  };
}
