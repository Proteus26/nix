{
  config,
  lib,
  pkgs,
  ...
}:

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
      nixfmt
      lua-language-server
      stylua
      shfmt

      # CLI tools
      wget
      unzip
      unrar
      eza
      ripgrep
      wireguard-tools
      jq
      playerctl
      ffmpeg

      # WM / Desktop related
      hyprpaper
      quickshell
      hyprshot
      wl-clipboard
      cliphist
      libnotify
      nwg-look

      # Apps
      vesktop
      yazi
      nautilus
      file-roller
      qbittorrent
      ghidra
      onlyoffice-desktopeditors
      stremio-linux-shell
      pavucontrol
      eiskaltdcpp
      krita
      brave
      kdePackages.kdeconnect-kde
    ];
  };
}
