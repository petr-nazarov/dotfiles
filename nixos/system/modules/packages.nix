
{ config, pkgs, systemSettings, ... }:

{
  imports = [
    #./packages/zsh.nix
    ./packages/tmux.nix
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
      #make
      cmake
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
      poppler
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
      pulumi-bin
      heroku
      google-cloud-sdk
      doppler
      hcloud
      # Programming language
      jre8
      python3
      python311Packages.pip
      ruby
      go
      nodejs_20
      tree-sitter
      bun
      nodePackages.neovim
        nodePackages.yarn
        #nodePackages.tree-sitter
        #eslint 
        #prettier
        #typescript
        #yarn
        #pnpm
        #@biomejs/biome
        #@johnnymorganz/stylua-bin
      # TUI programs
      tmux
      tmuxinator
      vim
      neovim
      lunarvim
      lazygit
      yazi
      btop

  ];



}
