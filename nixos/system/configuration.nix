# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
      ./modules/boot.nix
      ./modules/core.nix
      ./modules/user.nix
      ./modules/i18n.nix
      ./modules/network.nix
      ./modules/packages.nix
      ./modules/sound.nix
      ./modules/display.nix
      <home-manager/nixos> 
    ];
  networking.hostName = "desktop"; # Define your hostname.


}
