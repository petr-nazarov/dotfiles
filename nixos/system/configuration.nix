# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, systemSettings, ... }:

{
  imports =
    (if (systemSettings.hostname == "desktop") then [
      ./hardware/desktop-hardware-configuration.nix
    ] else [])
    ++ (if (systemSettings.hostname == "matebook") then [
      ./hardware/matebook-hardware-configuration.nix
      ./modules/laptop.nix
    ] else [])
    ++ (if (systemSettings.hostname == "dev-server") then [
      ./hardware/dev-server-hardware-configuration.nix
      ./modules/dev-server.nix
    ] else [])
    ++ [ 
      ./modules/core.nix
      ./modules/user.nix
      ./modules/i18n.nix
      ./modules/packages.nix
      ./modules/timers.nix
    ] ++ (if (systemSettings.gui) then [
      ./modules/sound.nix
      ./modules/display.nix
      ./modules/gui-packages.nix
      #./modules/services/ulauncher.nix
      ./modules/hardware-acceleration.nix
    ] else [ ]);
  networking.hostName = systemSettings.hostname; # Define your hostname.
}
