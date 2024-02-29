
{ config, pkgs, ... }:
{
  
  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    ".gitconfig".source = /home/nazarov/dotfiles/.gitconfig;
    "yoobic.gitconfig".source = /home/nazarov/dotfiles/yoobic.gitconfig;
    ".ssh/config".source = /home/nazarov/dotfiles/.ssh/config;
    ".tmux.conf".source = /home/nazarov/dotfiles/.tmux.conf;
    ".tmuxinator".source = /home/nazarov/dotfiles/.tmuxinator;
    ".config" = { source = /home/nazarov/dotfiles/.config; recursive=true; };
    "Projects/Personal/.keep".text = "";
    "Projects/Yoobic/.keep".text = "";
    "Downloads/Work/.keep".text = "";
    "Downloads/Scetch/.keep".text = "";
    "Screenshots/.keep".text = "";
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
