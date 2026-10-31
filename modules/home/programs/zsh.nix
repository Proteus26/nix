{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.features.home.programs.zsh;
in
{
  options.features.home.programs.zsh.enable = lib.mkEnableOption "zsh (home-manager)";

  config = lib.mkIf cfg.enable {
    programs.zsh = {
      enable = true;
      enableCompletion = true;

      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      history = {
        size = 10000;
        save = 10000;
      };

      shellAliases = {
        zshconfig = "nvim ~/nix/modules/home/programs/zsh.nix";
        docker-dev = "docker compose --profile dev";
        docker-prod = "docker compose --profile prod";
        ssh = "TERM=\"xterm-256color\" kitty +kitten ssh";
        ls = "eza -a --icons=auto";
        ll = "eza -lh --icons=auto --git";
        la = "eza -lah --icons=auto --git";
        tree = "eza --tree --icons=auto";
        grep = "rg --color=auto";
        diff = "diff --color=auto";
        df = "df -h";
      };

      initContent = ''
        compdef eza=ls

        # Enter one of the devshells from this flake: `devshell cpp`.
        # Runs zsh inside the shell instead of nix develop's default bash.
        devshell() {
          local flake="''${NH_FLAKE:-$HOME/nix}"
          if [ -z "$1" ]; then
            echo "Usage: devshell <shell_name>"
            echo "Available: $(nix eval --raw "$flake#devShells.x86_64-linux" --apply 'd: toString (builtins.attrNames d)' 2>/dev/null)"
            return 1
          fi
          nix develop "$flake#$1" --command zsh
        }

        # Show the active devshell on the right of the prompt.
        if [ -n "$IN_NIX_SHELL" ]; then
          RPROMPT="%F{blue}(''${DEVSHELL_NAME:-nix-shell})%f"
        fi

        # Only for top-level shells: inside a devshell the outer PATH (which
        # already has these) comes after the devshell's tools, so they win.
        if [ -z "$IN_NIX_SHELL" ]; then
          export PATH="$HOME/.local/bin:$HOME/.npm-global/bin:$PATH"
        fi
      '';

      oh-my-zsh = {
        enable = true;
        theme = "robbyrussell";
        plugins = [ "git" ];
      };

      plugins = [
        {
          name = "fzf-tab";
          src = "${pkgs.zsh-fzf-tab}/share/fzf-tab";
        }
      ];
    };

    home.sessionVariables.EDITOR = "nvim";

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
