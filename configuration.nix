# Główna konfiguracja systemu
{ config, lib, pkgs, inputs, ... }: {
  # Włączenie bootloadera systemd-boot (wspiera UEFI w OCI)
  boot.loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot.enable = true;
  };

  # Zabezpieczenie partycji /boot
  fileSystems."/boot".options = [ "fmask=0007" "dmask=0007" ];

  # Język
  i18n.defaultLocale = "pl_PL.UTF-8";

  # Sieć
  networking = {
    firewall.enable = false;
    hostName = "Oracle-VPS";
    networkmanager.enable = true;
    useDHCP = lib.mkDefault true; # Kluczowe dla chmury: upewnia się, że DHCP zadziała niezależnie od NM
  };

  nix = {
    registry.latest.flake = inputs.nixpkgs-unstable; # Żeby w terminalu było dostępne 'nix search latest <paczka>'
    registry.stable.flake = inputs.nixpkgs; # Żeby w terminalu było dostępne 'nix search stable <paczka>'
    settings.experimental-features = [ "nix-command" "flakes" ]; # Włączenie obsługi Flakes również w nowym systemie
  };

  # Żeby w 'apps.nix' można było używać 'latest.<paczka>'
  nixpkgs.overlays = [
    (final: prev: {
      latest = import inputs.nixpkgs-unstable.outPath {
        system = final.stdenv.hostPlatform.system;
      };

      stable = import inputs.nixpkgs.outPath {
        system = final.stdenv.hostPlatform.system;
      };
    })
  ];

  # Uruchamiaj ssh-agent
  programs.ssh.startAgent = true;

  # Sudo
  security.sudo = {
    extraRules = [{
      users = [ "nixos" ];
      commands = [
        { command = "/run/wrappers/bin/su"; options = [ "NOPASSWD" ]; }
        { command = "/run/current-system/sw/bin/systemctl start k3s.service"; options = [ "NOPASSWD" ]; }
        { command = "/run/current-system/sw/bin/systemctl stop k3s.service"; options = [ "NOPASSWD" ]; }
        { command = "/run/current-system/sw/bin/systemctl status k3s.service"; options = [ "NOPASSWD" ]; }
      ];
    }];
  };

  # Uslugi
  services = {
    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "no";
      };
    };

    k3s = {
      enable = true;
      role = "server";
      extraFlags = [
        "--write-kubeconfig-mode 0640"
        "--write-kubeconfig-group k3s"
      ];
    };
  };

  # Wersja systemu, z której startujesz
  system.stateVersion = "26.05";

  # SystemD
  systemd.services.k3s = {
    preStart = ''
      mkdir -p /var/lib/rancher/k3s/server/manifests
      cp /etc/k3s-manifests/traefik-dashboard-config.yaml /var/lib/rancher/k3s/server/manifests/traefik-dashboard-config.yaml
    '';
    wantedBy = lib.mkForce [];
  };

  # Strefa czasowa
  time.timeZone = "Europe/Warsaw";

  # Uzytkownicy
  users = {
    groups.k3s = {};

    users.nixos = {
      description = "NixOS";
      extraGroups = [ "k3s" ];
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDIQlxYmv7CyUcZlHVIgiZrby/4g8+cDqtB1dMhhn9Co2/PlLyo1et4HhdEMEOS5G/9GT9sW1LDQbOI0Vpp3GtAOlDLyPrr/V7rP3WwGvs7JcS49cjs+/nfkyoUpJXz6J39bxpMDxhMb4krqPvOLFlxq6gmwMjREDaUen9wGi/0W+FLCK1a908n5sLx5BoE4TSBoqgOiu71TMRC5Cs40i7rHDFF16UL09XHRoA5sXrvwH949yKGfC2ThSsOXJ/6GPUFysAbY4e8zScHKAELFJQOgMiT6yE2N8SP3TU8BM2Q4Dms80VlSQKzVNtm2JcxQ8HWBth59+C6P0fwQYIoSYVH ThinkPadT460p"
      ];
    };
  };
}
