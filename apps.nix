{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    pkgs.unstable.htop
    pkgs.unstable.tmux
    k3s
    pkgs.unstable.nmap
    pkgs.unstable.tcpdump
    pkgs.unstable.git
    pkgs.unstable.lazygit
  ];
}
