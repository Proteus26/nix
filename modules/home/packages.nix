{ config, lib, pkgs, ... }:

let
  cfg = config.features.home.packages;
in
{
  options.features.home.packages.enable = lib.mkEnableOption "user packages";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      # Dev tools
      docker-compose
      docker-buildx
      tree-sitter
      neovim
      tmux
      opencode
      nil
      lua-language-server

      # CLI tools
      wget
      unzip
      eza
      ripgrep
      btop
      wireguard-tools
      jq
      playerctl

      # WM / Desktop related
      hyprpaper
      hyprlock
      hyprshot
      quickshell
      wl-clipboard
      cliphist
      libnotify
      nwg-look

      # Apps
      kitty
      firefox
      vesktop
      yazi
      nautilus
      file-roller
      qbittorrent
      mpv
      ghidra
      onlyoffice-desktopeditors
      stremio-linux-shell
      pavucontrol
    ];
  };
}
