
{ config, pkgs, systemSettings, ... }:

{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${systemSettings.shared.username} = {
    isNormalUser = true;
    shell = pkgs.zsh;
    description = "Petr Nazarov";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
  };
}
