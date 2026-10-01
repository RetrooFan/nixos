{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    stable.k3s

    latest.git
    latest.htop
    latest.iftop
    latest.k9s
    latest.lazygit
    latest.nmap
    latest.tcpdump
    latest.tmux
    latest.micro

    (pkgs.writeShellScriptBin "compare-nixos-files" (builtins.readFile ./compare-nixos-files))
    (pkgs.writeShellScriptBin "copyfiles" (builtins.readFile ./copyfiles))
  ];
}
