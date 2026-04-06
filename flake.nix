{
  description = "NixOS configurations for gaia and future hosts";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, disko, ... }:
    {
      nixosConfigurations.gaia = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          disko.nixosModules.default
          ({ config, pkgs, ... }: {
            nixpkgs.config.allowUnfree = true;
          })
          ./hosts/gaia
        ];
      };
    };
}
