{ config, pkgs, systemSettings, ... }:

{
  imports = [
    ./modules/core.nix
    ./modules/files.nix
    ./modules/env.nix
    ./modules/packages.nix
    ./modules/sh.nix
    ] ++ (if (systemSettings.gui) then [
      ./modules/display.nix
      ./modules/gui-packages.nix
      ./modules/programs/firefox.nix
    ] else [ ]);
}
