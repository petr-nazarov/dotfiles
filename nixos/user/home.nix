{ config, pkgs, systemSettings, ... }:

{
  imports = [
     ./modules/sh.nix
     ./modules/core.nix
     ./modules/files.nix
     ./modules/env.nix
  ] ++ (if systemSettings.gui then 
    [ 
    #./modules/gnome.nix
    #./modules/plasma/plasma.nix
    ./modules/hyprland.nix
    ]
  else []);
}
