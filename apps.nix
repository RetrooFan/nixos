{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    stable.k3s

    latest.direnv
    latest.git
    latest.htop
    latest.iftop
    latest.k9s
    latest.lazygit
    latest.micro
    latest.nmap
    latest.tcpdump
    latest.tmux

    (pkgs.writeShellScriptBin "copy-config-to-home" (builtins.readFile ./copy-config-to-home))
  ];
}
