# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  self,
  ...
}: {
  # You can import other NixOS modules here
  imports = [
    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
    ];

    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  # This will add each flake input as a registry
  # To make nix3 commands consistent with your flake
  nix.registry = (lib.mapAttrs (_: flake: {inherit flake;})) ((lib.filterAttrs (_: lib.isType "flake")) inputs);

  # This will additionally add your inputs to the system's legacy channels
  # Making legacy nix commands consistent as well, awesome!
  nix.nixPath = ["/etc/nix/path"];
  environment.etc =
    lib.mapAttrs'
    (name: value: {
      name = "nix/path/${name}";
      value.source = value.flake;
    })
    config.nix.registry;

  nix.settings = {
    # Enable flakes and new 'nix' command
    experimental-features = "nix-command flakes";
    # Deduplicate and optimize nix store
    auto-optimise-store = true;
    trusted-users = [ "root" "@wheel" ];
    warn-dirty = false;
  };
  nix.gc = {
    automatic = true;
    options = "--delete-older-than 5d";
  };
  nix.optimise.automatic = true;

  time = {
    timeZone = "Europe/Paris";
    hardwareClockInLocalTime = true;
  };
  
  i18n.defaultLocale = "fr_FR.UTF-8";

  networking.hostName = "snOwOS";

  boot.loader.systemd-boot.enable = true;
  
  security.sudo.enable = true;
  services.blueman.enable = true;
  location.provider = "geoclue2";

  # Load some fonts  
  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
  ];

  #console.keyMap = "fr";
  console.useXkbConfig = true;

  # Enable zsh
  programs.zsh.enable = true;

  users.users = {
    snow = {
      isNormalUser = true;
      extraGroups = ["wheel" "networkmanager" "audio" "video" "libvirtd"];
      shell = pkgs.zsh;
    };
  };

  sound.enable = true;
  hardware.pulseaudio.enable = true;
  security.rtkit.enable = true;
  virtualisation = {
    libvirtd.enable = true;
  };
  services.dbus.enable = true;
  environment.systemPackages = with pkgs; [
    greetd.tuigreet
    nodejs
    blueman
    bluez
    pulseaudioFull
    bluez-tools
    xorg.xwininfo
    brightnessctl
    pulseaudio
    python3
    xdg-utils
    gtk3
    firefox
    git
  ];  

  environment.shells = with pkgs; [ zsh ];
  environment.sessionVariables.WLR_NO_HARDWARE_CURSORS = "1";
  
  programs.dconf.enable = true;

  qt = {
    enable = true;
    platformTheme = "gtk2";
    style = "gtk2";
  };
  
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
  };
  
  security.polkit.enable = true;

  xdg.portal.enable = true;
  xdg.portal.extraPortals = with pkgs; [
    xdg-desktop-portal-hyprland
    xdg-desktop-portal-gtk
  ];

  services = {
    printing.enable = true;
    gvfs.enable = true;
    power-profiles-daemon.enable = false;
    tlp.enable = true;
    upower.enable = true;
    xserver = {
      enable = true;
      layout = "fr";
      xkbVariant = "mac";
      libinput = {
        enable = true;
        touchpad = {
          tapping = true;
          middleEmulation = true;
          naturalScrolling = true;
        };
      };

    };
    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --user-menu --remember --cmd Hyprland";
          user = "snow";
        };
      };
    };
  };
  
  # Prevent systemd spam on tuigreet interface
  systemd.services.greetd.serviceConfig = {
    Type = "idle";
    StandardInput = "tty";
    StantardOutput = "tty";
    StandardError = "journal";
    TTYReset = true;
    TTYVHangup = true;
    TTYVTDisallocate = true;
  }; 

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";
}
