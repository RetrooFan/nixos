{ pkgs, ... }: {
  environment.etc."tmux.conf".text = builtins.readFile ./tmux.conf;
}
