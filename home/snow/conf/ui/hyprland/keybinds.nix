{ pkgs, ... }:

{
  wayland.windowManager.hyprland.settings = {
    "$mod" = "SUPER";
    bindr = [
      "$mod, $mod_L, exec, pkill rofi || rofi -show drun -modi drun,filebrowser,run"
    ];

    bind = [
      "$mod, D, exec, pkill rofi || rofi -show drun -modi drun,filebrowser,run"

      "$mod, Return, exec, kitty"
      "$mod, F, fullscreen"
      "$mod SHIFT, A, closewindow"
      "$mod, A, killactive"
      "$mod ALT, P, exec, wlogout"
    ];
  };
}
