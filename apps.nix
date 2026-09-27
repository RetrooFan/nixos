{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    stable.k3s
    latest.git
    latest.htop
    latest.lazygit
    latest.nmap
    latest.tcpdump
    latest.tmux
  ];
}
