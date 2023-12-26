{
  description = "SnoW's nixOS and home-manager config";

  inputs = {
    # Packages sources
    stable.url = "github:nixos/nixpkgs/nixos-23.05";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-colors.url = "github:misterio77/nix-colors";
    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    # Channels to follow
    home-manager.inputs.nixpkgs.follows = "unstable";
    nixpkgs.follows = "unstable";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    hyprland,
    hyprland-plugins,
    nix-colors,
    ...
  } @ inputs: let
    inherit (self) outputs;
    forSystems = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed;
    system = "aarch64-linux";
    pkgs = import nixpkgs {
      inherit system;
    };
  in {
    # NixOS configuration entrypoint
    nixosConfigurations = {
      snOwOS = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs home-manager hyprland hyprland-plugins;};
        modules = [home-manager.nixosModule ./hosts/snOwOS/configuration.nix];
      };
    };

    home-manager = home-manager.packages.${nixpkgs.system}."home-manager";

    # Standalone home-manager configuration entrypoint
    homeConfigurations = {
      snow = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.aarch64-linux; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = { inherit inputs outputs home-manager nix-colors self; };
        # > Our main home-manager configuration file <
        modules = [./home/snow/home.nix];
      };
    };
    
    snOwOS = self.nixosConfigurations.snOwOS.config.system.build.toplevel;
  };
}
