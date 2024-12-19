
{ config, pkgs, systemSettings, ... }:

{

  # Enable the X11 windowing system.
  services.xserver.enable = true;


  services.xserver.displayManager.gdm= {
    enable = true;
  };

  security.polkit.enable = true;


}
