{ config, lib, ... }:

let
  cfg = config.features.programs.zsh;
in
{
  options.features.programs.zsh.enable = lib.mkEnableOption "zsh";

  config = lib.mkIf cfg.enable {
    programs.zsh = {
      enable = true;
      # home-manager runs compinit and sets the prompt.
      enableCompletion = false;
      promptInit = "";
    };
  };
}
