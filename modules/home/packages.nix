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
      nil
      nixfmt
      lua-language-server
      stylua
      shfmt
      shellcheck
      statix

      # Languages
      gcc
      gnumake
      cmake
      ninja
      pkg-config
      clang-tools
      bear
      gdb
      gtest
      go
      gopls
      delve
      gotools
      golangci-lint
      maven
      gradle
      jdt-language-server
      google-java-format
      kotlin
      kotlin-language-server
      ktlint
      elan
      python3
      pyright
      ruff
      rustup
      openssl
      nodejs_24
      pnpm
      typescript
      typescript-language-server

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
      uv
      lsof

      # WM / Desktop related
      hyprpicker
      wl-clipboard
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
      claude-code
      antigravity-acp
      qimgv
    ];
  };
}
