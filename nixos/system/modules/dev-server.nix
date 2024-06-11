
{ config, pkgs, systemSettings, ... }:

{
  #imports = [
    #(fetchTarball {
    #url = "https://github.com/nix-community/nixos-vscode-server/tarball/master";
    #sha256 = "1rq8mrlmbzpcbv9ys0x88alw30ks70jlmvnfr2j8v830yy5wvw7h";
    #}
    #)
  #];
  #services.vscode-server.enable = true;
  #users.users.${systemSettings.shared.username}.packages = with pkgs; [
   #nixpkgs-fmt
  #];
  services.openssh = {
    enable = true;
  };
  networking.firewall.enable = false;

}
