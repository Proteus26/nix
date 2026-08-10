{
  config,
  lib,
  pkgs,
  hostspec,
  inputs,
  ...
}:

{
  imports = [
    ../../hardware-configuration.nix
    ../../modules/nixos
  ];

  # Identity (single source of truth, shared with home-manager via
  # home-manager.extraSpecialArgs below).
  system.stateVersion = hostspec.stateVersion;
  networking.hostName = hostspec.hostname;

  # Host-specific networking data.
  networking.extraHosts = ''
    172.16.91.124  hpc01.sharanga.local hpc01
    172.16.91.125  hpc02.sharanga.local hpc02
  '';

  # Feature flags: the host only toggles what it wants. Dependencies are
  # pulled in by the modules themselves (e.g. hyprland enables portal).
  features = {
    desktop = {
      hyprland.enable = true;
    };

    environment = {
      env.enable = true;
      packages.enable = true;
      fonts.enable = true;
    };

    filesystems.mounts.enable = true;

    hardware.graphics.enable = true;

    networking.enable = true;

    programs = {
      appimage.enable = true;
      dconf.enable = true;
      direnv.enable = true;
      nix-ld.enable = true;
      steam.enable = true;
      zsh.enable = true;
    };

    services = {
      audio.enable = true;
      bluetooth.enable = true;
      mounts.enable = true;
      power.enable = true;
      printing.enable = true;
      ssh.enable = true;
    };

    virtualisation.docker.enable = true;
  };

  home-manager = {
    # Share the system pkgs instance (so nixpkgs.config.allowUnfree etc.
    # apply to home-manager) and build user packages into the user profile.
    useGlobalPkgs = true;
    useUserPackages = true;

    backupFileExtension = "backup";

    extraSpecialArgs = { inherit hostspec inputs; };

    users.${hostspec.username} = {
      imports = [ ../../modules/home ];
    };
  };
}
