{ pkgs, hyprland, hyprland-plugins,... }:

let
  swww_script = import ../../../misc/swww.nix {inherit pkgs; };
in
{
  systemd.user.targets.hyprland-session.Unit.Wants = [ "xdg-desktop-autostart.target" ];
  wayland.windowManager.hyprland = {
    enable = true;
    package = hyprland.packages.${pkgs.system}.hyprland;
    systemd.enable = true;
    #plugins = [ hyprland-plugins.packages.${pkgs.system}.hyprbars ];
    settings = {
      "$mod" = "SUPER";

      xwayland.force_zero_scaling = true;

      monitor = ",1920x1200,auto,1";
      general = {
        border_size = 2;

	sensitivity = 1.00;
	apply_sens_to_raw = 1;
	gaps_in = 4;
	gaps_out = 8;
        resize_on_border = true;

	layout = "master";
      };
      
      dwindle = {
        pseudotile = "yes";
	preserve_split = "yes";
	special_scale_factor = 0.8;
      };

      master = {
        new_is_master = 1;
	new_on_top = 1;
	mfact = 0.5;
      };

      decoration = {
        rounding = 8;

	active_opacity = 1.0;
	inactive_opacity = 0.9;
	
	dim_inactive = true;
	dim_strength = 0.1;

	drop_shadow = true;
	shadow_range = 6;
	shadow_render_power = 1;
        #col.shadow = ;
        #	col.shadow_inactive = "0x50000000";
        
	blur = {
          enabled = true;
	  size = 5;
	  passes = 2;
	  ignore_opacity = true;
	  new_optimizations = true;
	};
      };

      input = {
        kb_layout = "fr";
	kb_variant = "mac";
	kb_options = "grp:alt_shift_toggle";
	numlock_by_default = 1;
	left_handed = 0;
	follow_mouse = 1;
	float_switch_override_focus = 0;
	touchpad = {
	  disable_while_typing = 1;
	  natural_scroll = "yes";
	  middle_button_emulation = 1;
	};
      };

      misc = {
        disable_splash_rendering = true;
	mouse_move_enables_dpms = true;
	enable_swallow = true;
	no_direct_scanout = true;
	focus_on_activate = false;
	swallow_regex = "^(kitty)$";
      };
      
      exec-once = [ 
        "waybar &"
	"swww init"
	"bash ${swww_script.swww_script}/bin/swww_script \"$HOME/wallpapers\""
      ];
    };

    extraConfig = ''
      bindr = $mod, $mod_L, exec, pkill rofi || rofi -show drun -modi drun,filebrowser,run
      bind = $mod, D, exec, pkill rofi || rofi -show drun -modi drun,filebrowser,run
  
      bind = $mod, Return, exec, kitty
      bind = $mod, F, fullscreen
      bind = $mod SHIFT, A, closewindow
      bind = $mod, A, killactive
      bind = $mod ALT, P, exec, wlogout
    '';
  };
}