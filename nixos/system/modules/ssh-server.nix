
{ config, pkgs, ... }:

{
  services.openssh = {
    enable = true;
  };
   networking.firewall.enable = false;
}
