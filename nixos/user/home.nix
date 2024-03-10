{ config, pkgs, systemSettings, ... }:

{
  imports = [
    ./modules/sh.nix
    ./modules/core.nix
    ./modules/files.nix
    ./modules/env.nix
  ] ++ (if systemSettings.gui then 
    [ ./modules/display.nix ]
  else []);
}
