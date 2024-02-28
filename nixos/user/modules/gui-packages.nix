
{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
      # GUI programs
      cinnamon.nemo-with-extensions
      kitty
      robo3t
  ];
}
