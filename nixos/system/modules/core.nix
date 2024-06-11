
{ config, pkgs, ... }:

{

  
  # Enable CUPS to print documents.
  services.printing.enable = true;
  security.rtkit.enable = true;

  virtualisation.docker.enable = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

#  nix.gc = {
#    automatic = true;
#    dates = "weekly";
#    options = "--delete-older-than 7d";
#  };


  #system.stateVersion = "23.11"; # Did you read the comment?
  system.stateVersion = "unstable"; # Did you read the comment?

  networking.networkmanager.enable = true;

}
