
{ config, pkgs, systemSettings, ... }:

let 
    gcloud = pkgs.google-cloud-sdk.withExtraComponents( with pkgs.google-cloud-sdk.components; [
      gke-gcloud-auth-plugin
    ]);

in
{
  imports = [
    #./packages/zsh.nix
    ./packages/tmux.nix
    ./packages/nvim.nix

  ];




  users.users.${systemSettings.shared.username}.packages = with pkgs; [


      # DevOps
      pulumi-bin
      heroku
      gcloud
      kubectl
      hcloud
      doppler
  ];



}
