{
  description = "Konfiguracja NixOS dla Oracle Cloud Ampere A1";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05"; # najnowsze stabilne wydanie
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable"; # Wydanie unstable
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, ... }@inputs: {
    nixosConfigurations.Oracle-VPS = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux"; # Dla maszyn Ampere A1 (ARM) musi być aarch64-linux

      # Aby udostępnić 'inputs' w configuration.nix
      specialArgs = { inherit inputs; };

      modules = [
        ./hardware-configuration.nix # Import automatycznie wykrytego sprzętu
        ./tmux.nix
        ./htop.nix
        ./nano.nix
        ./bash.nix
        ./apps.nix
        ./traefik.nix
        ./configuration.nix # Import głównej konfiguracji systemu
      ];
    };
  };
}
