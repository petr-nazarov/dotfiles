
{ config, pkgs, systemSettings, ... }:

{
  fileSystems."/mnt/storage" = {
    device = "/dev/disk/by-uuid/aa80dd61-a868-4035-aab3-cea5d1e6de50";
    fsType = "btrfs";
    options = [ "defaults"];
  };
}
