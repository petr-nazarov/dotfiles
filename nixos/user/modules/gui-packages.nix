
{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
      # GUI programs
      bitwarden
      cinnamon.nemo-with-extensions
      kitty
      robo3t
  ];
}
