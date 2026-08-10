{ ... }:

{
  imports = [
    ./graphics.nix
  ];

  # Intel CPU microcode + periodic NVMe TRIM.
  hardware.enableRedistributableFirmware = true;
  services.fstrim.enable = true;
}
