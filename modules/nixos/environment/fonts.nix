{ config, lib, pkgs, ... }:

let
  cfg = config.features.environment.fonts;
in
{
  options.features.environment.fonts.enable = lib.mkEnableOption "fonts";

  config = lib.mkIf cfg.enable {
    fonts = {
      packages = with pkgs; [
        inter
        rubik
        nerd-fonts.roboto-mono
        nerd-fonts.symbols-only
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-cjk-serif
        noto-fonts-color-emoji
        liberation_ttf
      ];

      fontconfig = {
        enable = true;
        defaultFonts = {
          sansSerif = [
            "Inter"
            "rubik"
            "Liberation Sans"
            "Noto Sans CJK JP"
            "Noto Color Emoji"
          ];
          serif = [
            "Liberation Serif"
            "Noto Serif CJK JP"
            "Noto Color Emoji"
          ];
          monospace = [
            "RobotoMono Nerd Font"
            "Noto Sans Mono CJK JP"
            "Noto Color Emoji"
          ];
          emoji = [ "Noto Color Emoji" ];
        };
        hinting = {
          enable = true;
          style = "slight";
        };
        antialias = true;
      };
    };
  };
}
