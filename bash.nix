{ pkgs, ... }: {
  environment.interactiveShellInit = builtins.readFile ./bashrc;
}
