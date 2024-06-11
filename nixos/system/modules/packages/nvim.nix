
{ config, pkgs, pkgs-unstable, systemSettings, ... }:
{

  users.users.${systemSettings.shared.username}.packages = with pkgs; [

      # utils
      bat
      fzf
      fd
      ripgrep
      yazi
      tree-sitter

      # Programming language
      python3
      python311Packages.pip
      ruby
      go
      rustc cargo
      nodejs_20

      # node deps 
      nodePackages.neovim
      nodePackages.yarn
      nodePackages.eslint 
      nodePackages.prettier
      nodePackages.typescript
      nodePackages.yarn
      nodePackages.pnpm


      # bin programs
      vim
      neovim
      lunarvim

  ]
  ++ [
  pkgs-unstable.neovim
  ];
}
