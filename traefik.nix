{ pkgs, ... }: {
  environment.etc."k3s-manifests/traefik-dashboard-config.yaml".text = builtins.readFile ./traefik-dashboard-config.yaml;
}
