{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Dev tools
    git
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
    fzf
    zoxide
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
}
