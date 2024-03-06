
{ config, pkgs, ... }:
let 
  #flake-compat = builtins.fetchTarball {url = "https://github.com/edolstra/flake-compat/archive/master.tar.gz"; sha256="0m9grvfsbwmvgwaxvdzv6cmyvjnlww004gfxjvcl806ndqaxzy4j"; };

  #hyprland-flake = (import flake-compat {
    #src = builtins.fetchTarball {url = "https://github.com/hyprwm/Hyprland/archive/master.tar.gz"; sha256 = "0mzcxi913kg46pf6j08379az93v2ql48bl6njhhawing8p66mc3b";};
     
  #}).defaultNix;


in {

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  programs.hyprland = {
    enable = true;
#    package = hyprland-flake.packages.${pkgs.system}.hyprland;
  };

  xdg = {
    portal = {
      enable = true;
      wlr.enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
        #xdg-desktop-portal-gtk
      ];
    };
  };

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  #services.xserver.desktopManager.gnome.enable = true;


  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };



  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

}
