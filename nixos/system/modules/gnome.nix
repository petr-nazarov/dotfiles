
{ config, pkgs, systemSettings, ... }:

{

  # Enable the X11 windowing system.
  services.xserver.enable = true;


  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm= {
    enable = true;
    autoLogin = {
      enable = true;
      user = "nazarov";
    };
    

  };
  services.xserver.desktopManager.gnome.enable = true;

  security.polkit.enable = true;



  # Configure keymap in X11
  services.xserver = {
    xkb.layout = "us";
    xkb.variant = "";
  };



  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

}
