{
  config,
  lib,
  pkgs,
  hostspec,
  ...
}:

{
  home.username = hostspec.username;
  home.homeDirectory = "/home/${hostspec.username}";
  home.stateVersion = hostspec.stateVersion;

  imports = [
    ./env.nix
    ./packages.nix
    ./programs
    ./files
  ];

  # Enable the home features this profile wants (each gated by its own module).
  features.home = {
    env.enable = true;
    packages.enable = true;
    programs.git.enable = true;
    programs.gh.enable = true;
    programs.zsh.enable = true;
    programs.kitty.enable = true;
    programs.mpv.enable = true;
    programs.btop.enable = true;
    programs.gtk.enable = true;
    programs.guitar-fx.enable = true;
    programs.firefox.enable = true;
    programs.vivaldi.enable = true;
    programs.t3code.enable = true;
    programs.figma-linux-next.enable = true;
    programs.hyprland.enable = true;
    programs.java.enable = true;
    programs.noctalia.enable = true;
    programs.kdeconnect.enable = true;
    programs.xdg.enable = true;
    files.dotfiles.enable = true;
    files.assets.enable = true;
  };
}
