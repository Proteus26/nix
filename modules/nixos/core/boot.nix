{ ... }:

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 5;
  boot.loader.efi.canTouchEfiVariables = true;

  # nvidia-drm modeset/fbdev are set by hardware.nvidia (hardware/graphics.nix).
  # pcie_aspm=off disables PCIe link power saving (costs battery); keep only if
  # it works around a real hardware issue on this machine.
  boot.kernelParams = [ "pcie_aspm=off" ];
}
