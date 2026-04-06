{
  description = "NixOS configurations for gaia and future hosts";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    hyprland.url = "github:hyprwm/Hyprland/v0.54.2";
  };

  outputs = { self, nixpkgs, hyprland, ... }:
    let
      overlay = final: prev: {
        hyprland = hyprland;
      };
    in
    {
      nixosConfigurations.gaia = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit hyprland; };
        modules = [
          ({ config, pkgs, ... }: {
            nixpkgs.config.allowUnfree = true;
            nixpkgs.overlays = [ overlay ];
          })
          ./hosts/gaia
        ];
      };
    };
}