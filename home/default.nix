{ config, pkgs, ... }:

{
  home.username = "proteus";
  home.homeDirectory = "/home/proteus";
  home.stateVersion = "26.05";

  imports = [
    ./packages.nix
    ./programs.nix
    ./dotfiles.nix
    ./assets.nix
  ];
}
