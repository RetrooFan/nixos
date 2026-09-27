{ pkgs, ... }: {
  environment.etc."k3s-manifests/traefik-dashboard-config.yaml".text = ''
# ------------------------------------------------
apiVersion: helm.cattle.io/v1
kind: HelmChartConfig
metadata:
  name: traefik
  namespace: kube-system
spec:
  valuesContent: |-
    api:
      dashboard: true
    ingressRoute:
      dashboard:
        enabled: true
    ports:
      traefik:
        expose:
          default: true
        exposedPort: 8080
        port: 8080
# ------------------------------------------------
  '';
}
