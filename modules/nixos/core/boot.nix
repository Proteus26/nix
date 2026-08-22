{ config, lib, ... }:

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 5;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelParams = [
    "nvidia-drm.modeset=1"
    "nvidia_drm.fbdev=1"
    "pcie_aspm=off"
  ];
}
