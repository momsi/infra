{
  description = "NixOS configurations for gaia and future hosts";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
  };

  outputs = { self, nixpkgs, ... }:
    {
      nixosConfigurations.gaia = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ({ config, pkgs, ... }: {
            nixpkgs.config.allowUnfree = true;
          })
          ./hosts/gaia
        ];
      };
    };
}
