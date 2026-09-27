{
  description = "Konfiguracja NixOS dla Oracle Cloud Ampere A1";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, ... }@inputs: {
    nixosConfigurations.Oracle-VPS = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux"; # Dla maszyn Ampere A1 (ARM) musi być aarch64-linux

      # Aby udostępnić 'inputs' w configuration.nix
      specialArgs = { inherit inputs; };

      modules = [
        ./hardware-configuration.nix
        ./tmux.nix
        ./htop.nix
        ./nano.nix
        ./bash.nix
        ./apps.nix
        ./traefik.nix
        ./configuration.nix
      ];
    };
  };
}
