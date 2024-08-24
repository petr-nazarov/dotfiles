
{ config, pkgs, systemSettings, ... }:

{
  fileSystems."/mnt/storage" = {
    device = "/dev/sda2"; # Replace with your actual device name
    fsType = "exfat";
    options = [ "auto" "rw" "uid=1000" "gid=100" ]; # Adjust uid and gid as needed
  };
}
