{
  description = "Konfiguracja NixOS dla Oracle Cloud Ampere A1";

  inputs = {
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, ... }@inputs: {
    nixosConfigurations.Oracle-VPS = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux"; # Dla maszyn Ampere A1 (ARM) musi być aarch64-linux
      specialArgs = { inherit inputs; }; # Aby udostępnić 'inputs' w configuration.nix

      modules = [
        ./hardware-configuration.nix
        ./configuration.nix
        ./apps.nix
      ];
    };
  };
}
