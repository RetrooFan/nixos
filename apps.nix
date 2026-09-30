{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    stable.k3s

    latest.git
    latest.htop
    latest.k9s
    latest.lazygit
    latest.nmap
    latest.tcpdump
    latest.tmux
    latest.micro

    (pkgs.writeShellScriptBin "compare" (builtins.readFile ./compare.sh))
    (pkgs.writeShellScriptBin "copyfiles" (builtins.readFile ./copyfiles.sh))
  ];
}
