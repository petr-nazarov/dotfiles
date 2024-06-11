
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
    ./packages/vscode.nix
    ./packages/nvim.nix

  ];

  environment.systemPackages = with pkgs; [
  ];

  programs.zsh.enable = true;

  fonts.packages = with pkgs; [
    # Fira Code
    #fira_code
    (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
  ];

  users.users.${systemSettings.shared.username}.packages = with pkgs; [
      # Build essentials
      cmake
      glib
      stdenv.cc.cc.lib
      gcc
      libgcc 

      # Essentials
      git
      wget
      curl

      # Command line utilities
      unzip
      unrar
      zsh
      antidote
      starship
      fd
      ripgrep
      bat
      fzf
      xclip
      procs
      eza

      # DevOps
      pulumi-bin
      heroku
      gcloud
      kubectl
      hcloud

      # Programming language
      jre8
      python3
      python311Packages.pip
      ruby
      go
      rustc cargo
      nodejs_20
      bun


      # TUI programs
      lazygit
      yazi
      btop

      doppler

  ];



}
