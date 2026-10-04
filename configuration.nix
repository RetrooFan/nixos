{ lib, inputs, ... }: {
  boot.loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot.enable = true;
  };

  environment = {
    etc = {
      "k3s-manifests/traefik-dashboard-config.yaml".text = builtins.readFile ./traefik-dashboard-config.yaml;

      "bashrc.local".text =                  builtins.readFile ./bashrc.local;
      "file-arrays".text =                   builtins.readFile ./file-arrays;
      "htoprc".text =                        builtins.readFile ./htoprc;
      "tmux.conf".text =                     builtins.readFile ./tmux.conf;

      "homefiles/gitconfig".text =           builtins.readFile ./homefiles/gitconfig;
      "homefiles/tmux.conf".text =           builtins.readFile ./homefiles/tmux.conf;
      "homefiles/alacritty.toml".text =      builtins.readFile ./homefiles/alacritty.toml;
      "homefiles/inputrc".text =             builtins.readFile ./homefiles/inputrc;
      "homefiles/lazygit.yml".text =         builtins.readFile ./homefiles/lazygit.yml;
      "homefiles/micro.bindings.json".text = builtins.readFile ./homefiles/micro.bindings.json;
      "homefiles/micro.settings.json".text = builtins.readFile ./homefiles/micro.settings.json;
      "homefiles/sublime.json".text =        builtins.readFile ./homefiles/sublime.json;
      "homefiles/vscode.json".text =         builtins.readFile ./homefiles/vscode.json;
    };

    interactiveShellInit = ''
      export REPO_USER="nixos"
      export REPO_DIR="/etc/nixos"
    '';
  };

  fileSystems."/boot".options = [ "fmask=0007" "dmask=0007" ]; # Zabezpieczenie partycji /boot
  i18n.defaultLocale = "pl_PL.UTF-8";

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

  nixpkgs.overlays = [
    (final: prev: {
      # Żeby w 'apps.nix' można było używać 'latest.<paczka>'
      latest = import inputs.nixpkgs-unstable.outPath {
        system = final.stdenv.hostPlatform.system;
      };

      # Żeby w 'apps.nix' można było używać 'stable.<paczka>'
      stable = import inputs.nixpkgs.outPath {
        system = final.stdenv.hostPlatform.system;
      };
    })
  ];

  programs = {
    nano = {
      enable = false;
      nanorc = builtins.readFile ./nanorc;
    };

    ssh.startAgent = true;
  };

  security.sudo.wheelNeedsPassword = false;

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

  system.stateVersion = "26.05"; # Startowa wersja systemu, nie wolno usuwać!

  systemd.services.k3s = {
    preStart = ''
      mkdir -p /var/lib/rancher/k3s/server/manifests
      cp /etc/k3s-manifests/traefik-dashboard-config.yaml /var/lib/rancher/k3s/server/manifests/traefik-dashboard-config.yaml
    '';
    wantedBy = lib.mkForce [];
  };

  time.timeZone = "Europe/Warsaw";

  users = {
    groups.k3s = {};

    users.nixos = {
      description = "NixOS";
      extraGroups = [ "wheel" "k3s" ];
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDIQlxYmv7CyUcZlHVIgiZrby/4g8+cDqtB1dMhhn9Co2/PlLyo1et4HhdEMEOS5G/9GT9sW1LDQbOI0Vpp3GtAOlDLyPrr/V7rP3WwGvs7JcS49cjs+/nfkyoUpJXz6J39bxpMDxhMb4krqPvOLFlxq6gmwMjREDaUen9wGi/0W+FLCK1a908n5sLx5BoE4TSBoqgOiu71TMRC5Cs40i7rHDFF16UL09XHRoA5sXrvwH949yKGfC2ThSsOXJ/6GPUFysAbY4e8zScHKAELFJQOgMiT6yE2N8SP3TU8BM2Q4Dms80VlSQKzVNtm2JcxQ8HWBth59+C6P0fwQYIoSYVH ThinkPadT460p"
      ];
    };
  };
}
