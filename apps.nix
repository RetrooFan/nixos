{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    latest.git
    latest.htop
    latest.lazygit
    latest.nmap
    latest.tcpdump
    latest.tmux
    k3s
  ];
}
