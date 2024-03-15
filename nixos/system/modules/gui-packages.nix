
{ config, pkgs, systemSettings, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./packages/chromium.nix
  ];
  users.users.${systemSettings.shared.username}.packages = with pkgs; [
      # display env and window manager related
      rofi-wayland fuzzel
      waybar
      libnotify swaynotificationcenter
      networkmanager_dmenu connman cmst  wpa_supplicant openvpn
      swww # wallpaper manager
      wl-clipboard cliphist xdotool python311Packages.tldextract
      pipewire wireplumber pavucontrol
      grim slurp grimblast # Screenshots
      # programs
      bitwarden
      slack
      zoom
      cinnamon.nemo-with-extensions
      kitty
      robo3t
      vlc 
      okular
      qbittorrent
  ];
}
