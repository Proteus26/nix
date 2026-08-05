{ ... }:

{
  # Thin wrapper so /etc/nixos can point here and for backwards compat.
  # The real entry point is ./hosts/nix/default.nix.
  imports = [
    ./hosts/nix
  ];
}
