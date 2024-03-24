
{ config, pkgs, systemSettings, ... }:

{

  nixpkgs.overlays = [
    (final: prev: {
      postman = prev.postman.overrideAttrs(old: rec {
        version = "20230716100528";
        src = final.fetchurl {
          url = "https://web.archive.org/web/${version}/https://dl.pstmn.io/download/latest/linux_64";
          sha256 = "sha256-svk60K4pZh0qRdx9+5OUTu0xgGXMhqvQTGTcmqBOMq8=";

          name = "${old.pname}-${version}.tar.gz";
        };
      });
    })
  ];
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
      bruno postman
      cinnamon.nemo-with-extensions
      kitty
      robo3t
      vlc 
      okular
      qbittorrent
  ];
}
