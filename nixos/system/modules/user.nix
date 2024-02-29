
{ config, pkgs, systemSettings, ... }:

{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${systemSettings.username} = {
    isNormalUser = true;
    shell = pkgs.zsh;
    description = "Petr Nazarov";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [
      # Build essentials
      #make
      cmake
      gcc
      libgcc 
      # Essentials
      git
      vim
      wget
    ];
  };
}
