
{ config, pkgs, ... }:
{
  
  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    ".gitconfig".source = ~/dotfiles/.gitconfig;
    "yoobic.gitconfig".source = ~/dotfiles/yoobic.gitconfig;
    ".ssh/config".source = ~/dotfiles/.ssh/config;
    ".tmux.conf".source = ~/dotfiles/.tmux.conf;
    ".tmuxinator".source = ~/dotfiles/.tmuxinator;
    ".config/" = { source = ~/dotfiles/.config; recursive=true; };
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
