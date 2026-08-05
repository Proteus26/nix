{ ... }:

{
  home.file = {
    ".themes/catppuccin-mocha-mauve-standard+default" = {
      source = ./assets/themes/catppuccin-mocha-mauve-standard+default;
      recursive = true;
    };
    ".themes/catppuccin-mocha-mauve-standard+default-hdpi" = {
      source = ./assets/themes/catppuccin-mocha-mauve-standard+default-hdpi;
      recursive = true;
    };
    ".themes/catppuccin-mocha-mauve-standard+default-xhdpi" = {
      source = ./assets/themes/catppuccin-mocha-mauve-standard+default-xhdpi;
      recursive = true;
    };
    ".icons/aosp-cursors" = {
      source = ./assets/icons/aosp-cursors;
      recursive = true;
      force = true;
    };
    "pictures/mayforest.jpg" = {
      source = ./assets/pictures/mayforest.jpg;
    };
  };
}
