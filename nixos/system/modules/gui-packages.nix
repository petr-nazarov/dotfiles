
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
    ./packages/chromium.nix
  ];

  users.users.${systemSettings.shared.username}.packages = with pkgs; [
      ## KDE
      #libsForQt5.polonium
      ## programs
      gnome.nautilus
      openrefine
      slack
      zoom
      bruno postman
      cinnamon.nemo-with-extensions
      kitty
      robo3t
      dbeaver-bin
      vlc 
      sioyek #pdf
      qbittorrent
      obs-studio
      moonlight-qt
  ];
}
