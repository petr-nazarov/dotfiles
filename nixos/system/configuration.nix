# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, systemSettings, ... }:

{
  imports =
    (if (systemSettings.hostname == "desktop") then [
      ./hardware/desktop-hardware-configuration.nix
      ./boot/desktop-boot.nix
    ] else [])
    ++ (if (systemSettings.hostname == "dev-server") then [
      ./hardware/dev-server-hardware-configuration.nix
      ./boot/dev-server-boot.nix
      ./modules/ssh-server.nix
    ] else [])
    ++ [ # Include the results of the hardware scan.
      ./modules/core.nix
      ./modules/user.nix
      ./modules/i18n.nix
      ./modules/network.nix
      ./modules/packages.nix
      ./modules/timers.nix
    ] ++ (if (systemSettings.gui) then [
      ./modules/sound.nix
      ./modules/display.nix
      ./modules/gui-packages.nix
    ] else [ ]);
  networking.hostName = systemSettings.hostname; # Define your hostname.
}
