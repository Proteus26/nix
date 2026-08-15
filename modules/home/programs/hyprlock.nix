{ config, lib, ... }:

let
  cfg = config.features.home.programs.hyprlock;

  colors = {
    text = "205, 214, 244";       # text
    textMuted = "166, 173, 200";  # subtext0
    textDim = "108, 112, 134";    # overlay0
    base = "30, 30, 46";          # base
    surface = "49, 50, 68";       # surface0
    border = "69, 71, 90";        # surface1
    accent = "137, 180, 250";     # blue
    bad = "243, 139, 168";        # red
  };
in
{
  options.features.home.programs.hyprlock.enable = lib.mkEnableOption "hyprlock";

  config = lib.mkIf cfg.enable {
    programs.hyprlock = {
      enable = true;

      settings = {
        background = [
          {
            monitor = "";
            path = "/home/proteus/pictures/mayforest.jpg";
            blur_passes = 2;
            blur_size = 4;
            contrast = 0.85;
            brightness = 0.22;
            vibrancy = 0.10;
            vibrancy_darkness = 0.20;
          }
        ];

        general = { };

        label = [
          {
            monitor = "";
            text = ''cmd[update:10000] echo -e "$(date +"%A, %B %d")"'';
            color = "rgba(${colors.textMuted}, 0.85)";
            font_size = 25;
            font_family = "Rubik Bold";
            position = "0, 250";
            halign = "center";
            valign = "center";
          }
          {
            monitor = "";
            text = ''cmd[update:10000] echo "<span>$(date +"%I:%M")</span>"'';
            color = "rgba(${colors.text}, 0.95)";
            font_size = 120;
            font_family = "Rubik Bold";
            position = "0, 150";
            halign = "center";
            valign = "center";
          }
          {
            monitor = "";
            text = "    $USER";
            color = "rgba(${colors.textMuted}, 0.9)";
            font_size = 18;
            font_family = "Rubik Bold";
            position = "0, -50";
            halign = "center";
            valign = "center";
          }
          {
            monitor = "";
            text = "<span>󰜉 </span>";
            color = "rgba(${colors.textMuted}, 0.75)";
            font_size = 50;
            onclick = "reboot now";
            position = "0, 100";
            halign = "center";
            valign = "bottom";
          }
          {
            monitor = "";
            text = "<span>󰐥 </span>";
            color = "rgba(${colors.textMuted}, 0.75)";
            font_size = 50;
            onclick = "shutdown now";
            position = "-140, 100";
            halign = "center";
            valign = "bottom";
          }
          {
            monitor = "";
            text = "<span>󰤄 </span>";
            color = "rgba(${colors.textMuted}, 0.75)";
            font_size = 50;
            onclick = "systemctl suspend";
            position = "140, 100";
            halign = "center";
            valign = "bottom";
          }
          {
            monitor = "";
            text = ''cmd[update:10000] sh -c '[ -f /sys/class/power_supply/BAT0/capacity ] || exit; cap=$(cat /sys/class/power_supply/BAT0/capacity); if [ "$cap" -ge 90 ]; then icon="󰁹"; elif [ "$cap" -ge 75 ]; then icon="󰂁"; elif [ "$cap" -ge 50 ]; then icon="󰁿"; elif [ "$cap" -ge 25 ]; then icon="󰁼"; else icon="󰁺"; fi; status=$(cat /sys/class/power_supply/BAT0/status); [ "$status" = "Charging" ] && icon="󰂄"; echo "$icon $cap%"'' + "'";
            color = "rgba(${colors.textMuted}, 0.85)";
            font_size = 16;
            font_family = "Rubik Bold";
            position = "-20, 20";
            halign = "right";
            valign = "bottom";
          }
        ];

        shape = [
          {
            monitor = "";
            size = "300, 60";
            color = "rgba(${colors.surface}, 0.55)";
            rounding = -1;
            border_size = 1;
            border_color = "rgba(${colors.border}, 0.7)";
            rotate = 0;
            xray = false;
            position = "0, -50";
            halign = "center";
            valign = "center";
          }
        ];

        input-field = [
          {
            monitor = "";
            size = "300, 60";
            outline_thickness = 2;
            dots_size = 0.2;
            dots_spacing = 0.2;
            dots_center = true;
            outer_color = "rgba(${colors.border}, 0.7)";
            inner_color = "rgba(${colors.base}, 0.6)";
            check_color = "rgba(${colors.accent}, 1.0)";
            fail_color = "rgba(${colors.bad}, 1.0)";
            font_color = "rgba(${colors.text}, 1.0)";
            fade_on_empty = false;
            font_family = "Rubik Bold";
            placeholder_text = ''<i><span foreground="##a6adc8">Password</span></i>'';
            hide_input = false;
            position = "0, -130";
            halign = "center";
            valign = "center";
          }
        ];
      };
    };
  };
}
