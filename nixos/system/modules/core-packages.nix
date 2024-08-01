
{ config, pkgs, systemSettings, ... }:

{
  imports = [
    #./packages/zsh.nix
    ./packages/tmux.nix
    ./packages/nvim.nix

  ];

  programs.zsh.enable = true;

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "/home/nazarov/dotfiles/nixos";
  };
  environment.systemPackages = with pkgs; [
    nix-output-monitor
  ];

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
      moreutils


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


  ];



}
