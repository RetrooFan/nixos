{ pkgs, ... }: {
  environment.etc."lazygit.conf.yml".text = builtins.readFile ./lazygit.conf.yml;
}
