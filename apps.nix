{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    stable.k3s
    stable.kubernetes-helm

    latest.git
    latest.htop
    latest.iftop
    latest.k9s
    latest.lazygit
    latest.nmap
    latest.tcpdump
    latest.tmux
    latest.micro

    (pkgs.writeShellScriptBin "copy-config-to-home" (builtins.readFile ./copy-config-to-home))
  ];
}
