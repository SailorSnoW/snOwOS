{ pkgs, config, ... }:

with config; {
  programs.kitty = {
    enable = true;
    theme = "Catppuccin-Mocha";
    settings = {
      font_family = "FiraCode Nerd Font Ret";
      font_size = 15;
      bold_font = "auto";
      italic_font = "auto";
      bold_italic_font = "auto";
      
      hide_window_decorations = "yes";
      x11_hide_window_decorations = "yes";
      
      window_padding_width = 6;      
      background_opacity = "0.7";
      confirm_os_window_close = 0;
      enable_audio_bell = "no";
    };

   # extraConfig = ''
   #   # Black
   #   color0 #${colorScheme.colors.base00}
   #   color8 #${colorScheme.colors.base00}

   #   # Red
   #   color1 #${colorScheme.colors.base01}
   #   color9 #${colorScheme.colors.base09}

   #   # Green
   #   color2 #${colorScheme.colors.base02}
   #   color10 #${colorScheme.colors.base0A}
   # '';
  };
}
