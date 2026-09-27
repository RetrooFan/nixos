{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    pkgs.unstable.git
    pkgs.unstable.htop
    pkgs.unstable.lazygit
    pkgs.unstable.nmap
    pkgs.unstable.tcpdump
    pkgs.unstable.tmux
    k3s
  ];
}
