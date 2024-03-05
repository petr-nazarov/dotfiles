
{ config, pkgs,lib, ... }:
{
  home.packages = with pkgs; [
      # GUI programs
      bitwarden
      slack
      zoom
      cinnamon.nemo-with-extensions
      kitty
      robo3t
      vlc 
      okular
      qbittorrent
  ];
}
