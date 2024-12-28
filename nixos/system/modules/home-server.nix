
{ config, pkgs, systemSettings, ... }:

{
  fileSystems."/mnt/storage" = {
    device = "/dev/sda1"; # Replace with your actual device name
    fsType = "exfat";
    options = [ "auto" "rw" "uid=1000" "gid=100" ]; # Adjust uid and gid as needed
  };
#  fileSystems."/mnt/data" = {
#    device = "/dev/nvme0n1p6"; # Replace with your actual device name
#    fsType = "exfat";
#    options = [ "auto" "rw" "uid=1000" "gid=100" ]; # Adjust uid and gid as needed
#  };
}
