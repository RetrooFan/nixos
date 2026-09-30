{ pkgs, ... }: {
  programs.nano.nanorc = builtins.readFile ./nanorc;
}
