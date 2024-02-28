{ config, pkgs, ... }:

{
  imports = [
    ./modules/core.nix
    ./modules/files.nix
    ./modules/env.nix
    ./modules/packages.nix
    ./modules/sh.nix
    ./modules/display.nix
    ./modules/programs/firefox.nix
  ]; 
}
