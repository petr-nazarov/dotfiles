
{ config, pkgs, ... }:
{
  
  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    ".gitconfig".source = /home/nazarov/dotfiles/.gitconfig;
    ".ssh/config".source = /home/nazarov/dotfiles/.ssh/config;
    #".tmux.conf".source = /home/nazarov/dotfiles/.tmux.conf;
    #".tmux/plugins/tmp" = { source =  builtins.fetchGit{url = "https://github.com/tmux-plugins/tpm"; ref="master"; }; recursive=true; };
    ".tmuxinator".source = /home/nazarov/dotfiles/.tmuxinator;
    
    # vscode
    #"~/.config/Code/User/settings.json".source = /home/nazarov/dotfiles/.config/vscode/settings.json;
    ".config" = { source = /home/nazarov/dotfiles/.config; recursive=true; };
    "Projects/Personal/.keep".text = "";
    "Projects/Yoobic/.keep".text = "";
    "Downloads/Work/.keep".text = "";
    "Downloads/Scetch/.keep".text = "";
    "Screenshots/.keep".text = "";
    #".secrets" = { source =  builtins.fetchGit{url = "git@github.com:petr-nazarov/.secrets.git"; ref= "master"; }; recursive=true; };
    "wallpapers" = { source =  builtins.fetchGit{url = "git@github.com:petr-nazarov/wallpapers.git"; ref="master"; }; recursive=true; };
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };
}
