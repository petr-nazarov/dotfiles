
{ config, pkgs, systemSettings, ... }:

{

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
}
