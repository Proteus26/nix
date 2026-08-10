{ config, lib, pkgs, hostspec, ... }:

{
  home.username = hostspec.username;
  home.homeDirectory = "/home/${hostspec.username}";
  home.stateVersion = hostspec.stateVersion;

  imports = [
    ./packages.nix
    ./programs
    ./files
  ];

  # Enable the home features this profile wants (each gated by its own module).
  features.home = {
    packages.enable = true;
    programs.git.enable = true;
    programs.zsh.enable = true;
    programs.kitty.enable = true;
    programs.mpv.enable = true;
    programs.btop.enable = true;
    programs.gtk.enable = true;
    programs.quickshell.enable = true;
    files.dotfiles.enable = true;
    files.assets.enable = true;
  };
}
