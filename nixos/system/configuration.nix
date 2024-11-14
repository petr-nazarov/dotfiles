# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, systemSettings, ... }:

{
  imports =
    (if (systemSettings.hostname == "desktop") then [
      ./hardware/desktop-hardware-configuration.nix
      ./modules/keyboard.nix
      ./modules/hypr.nix
      ./modules/sound.nix
      ./modules/gui-packages.nix
      ./modules/hardware-acceleration.nix
      ./modules/dev-packages.nix
      ./modules/timers.nix
      ./modules/ssh-server.nix
    ] else [])
    ++ (if (systemSettings.hostname == "matebook") then [
      ./hardware/matebook-hardware-configuration.nix
      ./modules/keyboard.nix
      ./modules/laptop.nix
      ./modules/hypr.nix
      ./modules/gnome-display-manager.nix
      ./modules/sound.nix
      ./modules/gui-packages.nix
      ./modules/hardware-acceleration.nix
      ./modules/dev-packages.nix
      ./modules/timers.nix
    ] else [])
    ++ (if (systemSettings.hostname == "dev-server") then [
      ./hardware/dev-server-hardware-configuration.nix
      ./modules/ssh-server.nix
      ./modules/dev-packages.nix
      ./modules/timers.nix
    ] else [])
    ++ (if (systemSettings.hostname == "home-server") then [
      ./hardware/home-server-hardware-configuration.nix
      ./modules/keyboard.nix
      ./modules/ssh-server.nix
      ./modules/jellyfin-client.nix
    ] else [])
    ++ [ 
      ./modules/core.nix
      ./modules/user.nix
      ./modules/i18n.nix
      ./modules/core-packages.nix
    ];
  networking.hostName = systemSettings.hostname; # Define your hostname.
}
