
{ config, pkgs, systemSettings, ... }:

{

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  #Hyprland
  programs.hyprland = {
    enable = true;
  };
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  users.users.${systemSettings.shared.username}.packages = with pkgs; [
      ## General utils
      tofi
      wl-clipboard cliphist xdotool python311Packages.tldextract
      polkit-kde-agent
      ## Hyprland
      brightnessctl 
      hypridle hyprlock
      libsForQt5.polkit-kde-agent
      networkmanagerapplet libsForQt5.plasma-nm blueman
      waybar
      libnotify swaynotificationcenter
      swww # wallpaper manager
      grim slurp grimblast # Screenshots
      pipewire wireplumber pavucontrol
  ];
  security.polkit.enable = true;
  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  #services.xserver.desktopManager.gnome.enable = true;
  #programs.dconf.enable = true;
  #environment.systemPackages = with pkgs; [
    #gnome.gnome-tweaks
    #gnomeExtensions.forge
  #];

  ## Enable KDE Desktop Environment
  #services.desktopManager.plasma6.enable = true;



  # Configure keymap in X11
  services.xserver = {
    xkb.layout = "us";
    xkb.variant = "";
  };



  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

}
