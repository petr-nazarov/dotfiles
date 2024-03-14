
{ config, pkgs, systemSettings, ... }:

{
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = [
    /home/nazarov/Downloads/Work/studio3t/studio-3t-linux-x64.sh
  ];
}
