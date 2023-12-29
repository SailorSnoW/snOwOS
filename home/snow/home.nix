# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  nix-colors,
  ...
}: 

let
  hyprland = inputs.hyprland;
  hyprland-plugins = inputs.hyprland-plugins;
in
{
  # You can import other home-manager modules here
  imports = [
    # Load schemes of nix-colors
    nix-colors.homeManagerModules.default
    (import ./conf/shell/zsh/default.nix { inherit pkgs; })
    (import ./conf/term/kitty/default.nix { inherit pkgs config; })
  #  (import ./conf/ui/hyprland/default.nix { inherit pkgs config; })
    (import ./conf/ui/wlogout/default.nix { inherit pkgs; })
    (import ./conf/ui/waybar/default.nix { inherit pkgs hyprland lib config; })
    (import ./conf/utils/rofi/default.nix { inherit pkgs; })
    (import ./misc/neofetch.nix { inherit pkgs lib config; })
    (import ./conf/utils/btop/default.nix { inherit pkgs; })
  ];

  wayland.windowManager.hyprland.enable = true;

  colorScheme = nix-colors.colorSchemes.catppuccin-mocha;

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  home = {
    username = "snow";
    homeDirectory = "/home/snow";

    packages = with pkgs; [
      neofetch
      swww
      xdg-desktop-portal
      killall
      xorg.xev
    ];
  };
  
  gtk = {
    enable = true;
    gtk3.extraConfig.gtk-decoration-layout = "menu:";
    #iconTheme.name = "Papirus";
    #theme.name = "phocus";
  };

  # Add stuff for your user as you see fit:
  programs.neovim.enable = true;
  programs.neovim.defaultEditor = true;

  # home.packages = with pkgs; [ steam ];

  # Enable home-manager and git
  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    userEmail = "sailorsnow@pm.me";
    userName = "SailorSnoW";
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
