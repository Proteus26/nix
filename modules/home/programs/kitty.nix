{ config, lib, ... }:

let
  cfg = config.features.home.programs.kitty;
in
{
  options.features.home.programs.kitty.enable = lib.mkEnableOption "kitty";

  config = lib.mkIf cfg.enable {
    programs.kitty = {
      enable = true;

      themeFile = "Catppuccin-Mocha";

      settings = {
        background_opacity = 1.0;
        background_blur = 1;
        confirm_os_window_close = 0;
        enable_audio_bell = false;
        shell = "zsh";

        font_family = "Roboto Mono Nerd Font";
        font_size = 12.0;

        cursor_shape = "beam";
        cursor_blink_interval = 0;
        cursor_stop_blinking_after = 0;
        shell_integration = "no-cursor";

        scrollback_lines = 5000;
        wheel_scroll_multiplier = 3.0;

        mouse_hide_wait = -1;

        remember_window_size = false;
        initial_window_width = 1200;
        initial_window_height = 750;
        window_border_width = "1.5pt";
        enabled_layouts = "tall";
        window_padding_width = 0;
        window_margin_width = 2;
        hide_window_decorations = false;

        kitty_mod = "alt+shift";

        tab_bar_style = "powerline";
        tab_powerline_style = "slanted";
        tab_bar_edge = "top";
        tab_bar_align = "left";
        active_tab_font_style = "bold";
        inactive_tab_font_style = "normal";
      };

      keybindings = {
        "ctrl+shift+backspace" = "change_font_size all 0";
        "ctrl+shift+c" = "copy_to_clipboard";
        "ctrl+shift+v" = "paste_from_clipboard";

        "kitty_mod+r" = "goto_layout tall";

        "kitty_mod+t" = "new_tab";
        "kitty_mod+l" = "next_tab";
        "kitty_mod+h" = "previous_tab";
        "alt+1" = "goto_tab 1";
        "alt+2" = "goto_tab 2";
        "alt+3" = "goto_tab 3";
        "alt+4" = "goto_tab 4";
        "alt+5" = "goto_tab 5";
        "alt+6" = "goto_tab 6";
        "alt+7" = "goto_tab 7";
        "alt+8" = "goto_tab 8";
        "alt+9" = "goto_tab 9";
        "alt+0" = "goto_tab 10";

        "kitty_mod+enter" = "new_window";
        "kitty_mod+]" = "next_window";
        "kitty_mod+[" = "previous_window";
        "kitty_mod+q" = "close_window";
        "kitty_mod+s" = "launch --location=hsplit";
        "kitty_mod+v" = "launch --location=vsplit";
        "kitty_mod+left" = "neighboring_window left";
        "kitty_mod+right" = "neighboring_window right";
        "kitty_mod+up" = "neighboring_window up";
        "kitty_mod+down" = "neighboring_window down";

        "ctrl+equal" = "change_font_size all +2.0";
        "ctrl+minus" = "change_font_size all -2.0";
      };
    };
  };
}
