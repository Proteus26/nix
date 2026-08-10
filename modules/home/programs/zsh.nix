{ config, lib, pkgs, ... }:

let
  cfg = config.features.home.programs.zsh;
in
{
  options.features.home.programs.zsh.enable = lib.mkEnableOption "zsh (home-manager)";

  config = lib.mkIf cfg.enable {
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      enableAutosuggestions = true;
      enableSyntaxHighlighting = true;

      history = {
        size = 10000;
        save = 10000;
      };

      shellAliases = {
        zshconfig = "nvim ~/nix/modules/home/programs/zsh.nix";
        docker-dev = "docker compose --profile dev";
        docker-prod = "docker compose --profile prod";
        ssh = "TERM=\"xterm-256color\" kitty +kitten ssh";
        ls = "eza -a --icons";
        ll = "eza -lh --icons --git";
        la = "eza -lah --icons --git";
        tree = "eza --tree --icons";
        grep = "rg --color=auto";
        diff = "diff --color=auto";
        df = "df -h";
      };

      initExtra = ''
        compdef eza=ls

        devshell() {
          if [ -z "$1" ]; then
            echo "Usage: devshell <shell_name>"
            echo "Example: devshell cpp"
          else
            nix develop "/home/proteus/nix#$1"
          fi
        }

        export EDITOR='nvim'
        export PATH="$HOME/.local/bin:$PATH"
        export PATH="/usr/local/go/bin/:$PATH"
        export PNPM_HOME="/home/proteus/.local/share/pnpm"
        export PATH="$HOME/.npm-global/bin:$PATH"
        case ":$PATH:" in
          *":$PNPM_HOME:"*) ;;
          *) export PATH="$PNPM_HOME:$PATH" ;;
        esac
        export PATH=/usr/local/cuda/bin''${PATH:+:''${PATH}}
        export LD_LIBRARY_PATH=/usr/local/cuda/lib64''${LD_LIBRARY_PATH:+:''${LD_LIBRARY_PATH}}
      '';

      oh-my-zsh = {
        enable = true;
        theme = "robbyrussell";
        plugins = [ "git" ];
      };
    };

    programs.zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
