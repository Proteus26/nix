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
      # Full security audit of fpath at most once a day; otherwise reuse the dump.
      completionInit = ''
        autoload -Uz compinit
        () {
          setopt local_options extended_glob
          if [[ -n ''${ZDOTDIR:-$HOME}/.zcompdump(#qN.mh+24) ]]; then
            compinit
          else
            compinit -C
          fi
        }
      '';

      defaultKeymap = "emacs";
      autosuggestion.enable = true;

      history = {
        size = 50000;
        save = 50000;
        ignoreAllDups = true;
        ignoreSpace = true;
        share = true;
        extended = true;
      };

      shellAliases = {
        zshconfig = "nvim ~/nix/modules/home/programs/zsh.nix";
        docker-dev = "docker compose --profile dev";
        docker-prod = "docker compose --profile prod";
        ssh = "TERM=\"xterm-256color\" kitten ssh";
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

        # Up/Down search history for commands starting with what's typed.
        autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
        zle -N up-line-or-beginning-search
        zle -N down-line-or-beginning-search
        for k in '^[[A' '^[OA'; do bindkey "$k" up-line-or-beginning-search; done
        for k in '^[[B' '^[OB'; do bindkey "$k" down-line-or-beginning-search; done

        # Ctrl/Alt + arrows move by word; Ctrl/Alt + Backspace/Delete delete by word.
        bindkey '^[[1;5D' backward-word
        bindkey '^[[1;3D' backward-word
        bindkey '^[[1;5C' forward-word
        bindkey '^[[1;3C' forward-word
        bindkey '^H' backward-kill-word
        bindkey '^[^?' backward-kill-word
        bindkey '^[[3;5~' kill-word
        bindkey '^[[3;3~' kill-word
        bindkey '^[[3~' delete-char
        # Stop word motions at / . - so paths are edited one part at a time.
        WORDCHARS=''${WORDCHARS//[\/.-]}

        # robbyrussell, without oh-my-zsh.
        _rr_git() {
          local ref
          ref=$(git symbolic-ref --short -q HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null) || return
          if [[ -n $(git status --porcelain --ignore-submodules=dirty 2>/dev/null | head -n1) ]]; then
            print -n "%B%F{blue}git:(%F{red}$ref%F{blue}) %F{yellow}✕%f%b "
          else
            print -n "%B%F{blue}git:(%F{red}$ref%F{blue})%f%b "
          fi
        }
        setopt prompt_subst
        PROMPT='%(?:%B%F{green}➜%b :%B%F{red}➜%b ) %F{cyan}%c%f $(_rr_git)'

        # Enter one of the devshells from this flake: `devshell cpp`.
        # Runs zsh inside the shell instead of nix develop's default bash.
        devshell() {
          local flake="''${NH_FLAKE:-$HOME/nix}"
          if [ -z "$1" ]; then
            echo "Usage: devshell <shell_name> [more shells...]"
            echo "Available: $(nix eval --raw "$flake#devShells.x86_64-linux" --apply 'd: toString (builtins.attrNames d)' 2>/dev/null)"
            return 1
          fi
          if [ $# -eq 1 ]; then
            nix develop "$flake#$1" --command zsh
          else
            nix develop --impure --expr "(builtins.getFlake \"path:$flake\").lib.mergeDevShells [ $(printf '"%s" ' "$@") ]" --command zsh
          fi
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

      plugins = [
        {
          name = "fzf-tab";
          src = "${pkgs.zsh-fzf-tab}/share/fzf-tab";
        }
        {
          name = "fast-syntax-highlighting";
          src = "${pkgs.zsh-fast-syntax-highlighting}/share/zsh/plugins/fast-syntax-highlighting";
        }
      ];
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
