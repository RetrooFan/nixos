{
  description = "Konfiguracja NixOS dla Oracle Cloud Ampere A1";

  inputs = {
    # Korzystamy z najnowszego stabilnego wydania NixOS
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    # Wydanie unstable
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, ... }@inputs: {
    nixosConfigurations.Oracle-VPS = nixpkgs.lib.nixosSystem {
      # Dla maszyn Ampere A1 (ARM) musi być aarch64-linux
      system = "aarch64-linux";

      modules = [
        ./hardware-configuration.nix # Import automatycznie wykrytego sprzętu
        ./tmux.nix
        ./htop.nix
        ./nano.nix
        ./bash.nix
        ./apps.nix
        ./traefik.nix
        ./configuration.nix # Import głównej konfiguracji systemu
        ({ config, pkgs, ... }: {
          nixpkgs.overlays = [
            (final: prev: {
              unstable = import nixpkgs-unstable {
                system = pkgs.system;
              };
            })
          ];
        })
      ];
    };
  };
}
