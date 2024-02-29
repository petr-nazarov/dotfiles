
{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
      # GUI essentials
      rofi-wayland
      fuzzel
      waybar
      wl-clipboard
      swww # wallpaper manager
      cliphist xdotool python311Packages.tldextract
      pipewire wireplumber
      grim slurp grimblast # Screenshots
  ];
  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 16;
  };
  
}
