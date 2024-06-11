
{ config, pkgs, ... }:

{
  imports = [
    ./timers/sync-vault.nix
  ];
}
