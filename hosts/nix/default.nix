{ ... }:

{
  imports = [
    ../../hardware-configuration.nix

    ../../modules/core.nix
    ../../modules/boot.nix
    ../../modules/locale.nix
    ../../modules/env.nix
    ../../modules/graphics.nix
    ../../modules/users.nix
    ../../modules/networking.nix
    ../../modules/services.nix
    ../../modules/desktop.nix
    ../../modules/programs.nix
    ../../modules/fonts.nix
    ../../modules/packages.nix
    ../../modules/filesystems.nix
    ../../modules/virtualisation.nix
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    backupFileExtension = "backup";

    users.proteus = import ../../home;
  };
}
