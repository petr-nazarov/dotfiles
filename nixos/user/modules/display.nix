
{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
      # GUI essentials
      rofi-wayland fuzzel
      waybar
      libnotify swaynotificationcenter
      networkmanager_dmenu connman
      swww # wallpaper manager
      wl-clipboard cliphist xdotool python311Packages.tldextract
      pipewire wireplumber pavucontrol
      grim slurp grimblast # Screenshots
  ];
  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 16;
  };
  
}
