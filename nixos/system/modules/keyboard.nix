
{ config, pkgs, systemSettings, ... }:

{


  # Configure keymap in X11
  services.xserver = {
    xkb.layout = "us";
    xkb.variant = "";
  };


}
