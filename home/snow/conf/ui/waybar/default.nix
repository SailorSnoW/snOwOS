{ config, lib, pkgs, hyprland, ... }:

{
  programs.waybar =
    with config;{
      enable = true;
      package = pkgs.waybar;
      systemd = {
        enable = false;
        target = "graphical-session.target";
      };
      style = ''
        window#waybar {
          /*background: transparent;*/
          transition-duration: 0.5s;
          background-color: #${colorScheme.colors.base00};
          color: #${colorScheme.colors.base05};
          border-radius: 10px;
        }
        #workspaces {
          font-family: "Material Design Icons Desktop";
          font-size: 20px;
          background-color: #${colorScheme.colors.base00};
          margin : 4px 0;
          border-radius : 5px;
        }
        #workspaces button {
          font-size: 18px;
          background-color: transparent;
          color: #${colorScheme.colors.base05};
          transition: all 0.1s ease;
        }
        #workspaces button.focused {
          font-size: 18px;
          color: #${colorScheme.colors.base03};
        }
        #workspaces button.persistent {
          color: #${colorScheme.colors.base07};
          font-size: 12px;
        }
        #custom-launcher {
          background-color: #${colorScheme.colors.base00};
          color: #${colorScheme.colors.base07};
          margin : 4px 4.5px;
          padding : 5px 12px;
          font-size: 18px;
          border-radius : 5px;
        }
        #custom-power {
          color : #${colorScheme.colors.base07};
          background-color: #${colorScheme.colors.base00};
          margin : 4px 4.5px 4px 4.5px;
          padding : 5px 11px 5px 13px;
          border-radius : 5px;
        }

        #clock {
          background-color: #${colorScheme.colors.base00};
          color: #${colorScheme.colors.base07};
          margin : 4px 9px;
          padding : 5px 12px;
          border-radius : 5px;
        }
        
        #network {
          color : #${colorScheme.colors.base07};
          background-color: #${colorScheme.colors.base00};
          margin : 4px 0 4px 4.5px;
          padding : 5px 12px;
          border-radius : 5px 0 0 5px;
        }
        #battery {
          color : #${colorScheme.colors.base07};
          background-color: #${colorScheme.colors.base00};
          margin : 4px 0px;
          padding : 5px 12px;
          border-radius : 5px 0 0 5px;
        }
        #custom-swallow {
          background-color: #${colorScheme.colors.base00};
          margin : 4px 4.5px;
          padding : 5px 12px;
          border-radius : 5px;
        }
        * {
          font-size: 16px;
          min-height: 0;
          font-family: "FiraCode Nerd Font";
        }
      '';
      settings = [{
        height = 35;
        layer = "top";
        position = "top";
        tray = { spacing = 10; };
        modules-center = [ "clock" ];
        modules-left = [ "custom/launcher" "hyprland/workspaces" ];
        modules-right = [
          "network"
          "battery"
          "custom/power"
          "tray"
        ];
        "hyprland/workspaces" = {
          on-click = "activate";
          all-outputs = true;
          format = "{icon}";
          disable-scroll = true;
          active-only = false;
          format-icons = {
            default = "󰊠 ";
            persistent = "󰊠 ";
            focused = "󰮯 ";
          };
          persistent_workspaces = {
            "1" = [ ];
            "2" = [ ];
            "3" = [ ];
            "4" = [ ];
            "5" = [ ];
          };
        };
        battery = {
          format = "{icon}";
          on-click = "eww open --toggle control";
          format-charging = " ";
          format-icons = [ "󰂎" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
          format-plugged = "󰚦 ";
          states = {
            critical = 15;
            warning = 30;
          };
        };
        clock = {
          format = "{:%d %A %H:%M}";
          tooltip-format = "{:%Y-%m-%d | %H:%M}";
        };
        network = {
          interval = 1;
          on-click = "eww open --toggle control";
          format-disconnected = "󰤮 ";
          format-wifi = "󰤨 ";
        };
        "custom/launcher" = {
          on-click = "eww open --toggle dash";
          format = " ";
        };
        "custom/power" = {
          on-click = "powermenu &";
          format = " ";
        };
      }];
    };
}
