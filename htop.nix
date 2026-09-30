{ pkgs, ... }: {
  environment.etc."htoprc".text = builtins.readFile ./htoprc;
}
