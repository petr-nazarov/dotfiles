# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, systemSettings, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./modules/boot.nix
      ./modules/core.nix
      ./modules/user.nix
      ./modules/i18n.nix
      ./modules/network.nix
      ./modules/packages.nix
    ] ++ (if (systemSettings.gui) then [
      ./modules/sound.nix
      ./modules/display.nix
    ] else [ ]);
  networking.hostName = systemSettings.hostname; # Define your hostname.
}
