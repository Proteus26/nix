{ ... }:

{
  networking.hostName = "nix";

  networking.networkmanager.enable = true;

  networking.extraHosts = ''
    172.16.91.124  hpc01.sharanga.local hpc01
    172.16.91.125  hpc02.sharanga.local hpc02
  '';
}
