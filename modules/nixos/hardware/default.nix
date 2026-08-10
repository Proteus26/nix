{ ... }:

{
  imports = [
    ./graphics.nix
  ];

  # Intel CPU: fetch + install microcode updates.
  hardware.enableRedistributableFirmware = true;

  # Periodic TRIM for the NVMe SSD.
  services.fstrim.enable = true;
}
