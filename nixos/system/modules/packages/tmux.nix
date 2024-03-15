
{ config, pkgs, ... }:

{

  programs.tmux = {
    enable = true;
    shortcut = "a";
    
    plugins = with pkgs; [
      tmuxPlugins.better-mouse-mode
      tmuxPlugins.vim-tmux-navigator
      tmuxPlugins.catppuccin
    ];
    extraConfig = ''

      #set -g default-terminal "screen-256color"
      #set -g default-terminal "xterm-256color"
      #set-option -ga terminal-overrides ",xterm-256color:Tc"
      #set-option  -ga terminal-overrides  ",xterm-kitty:Tc"
      #set -ga terminal-overrides ",*256col*:Tc"
      #set -ga terminal-overrides '*:Ss=\E[%p1%d q:Se=\E[ q'
      #set-environment -g COLORTERM "truecolor"
      #set-option -ga terminal-overrides ",xterm-256color:Tc"

      set-option -g default-terminal "screen-256color"
      set-option -sa terminal-features ',linux:RGB'

      set-option -sg escape-time 10

      # Mouse works as expected
      set-option -g mouse on
      # easy-to-remember split pane commands
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
      bind c new-window -c "#{pane_current_path}"

      bind -r j resize-pane -D 5
      bind -r k resize-pane -U 5
      bind -r l resize-pane -R 5
      bind -r h resize-pane -L 5
      bind -r m resize-pane -Z


      bind-key -T copy-mode-vi 'v' send -X begin-selection # start selecting text with "v"
      bind-key -T copy-mode-vi 'y' send -X copy-selection # copy text with "y"

      set-window-option -g mode-keys vi
      set -g @catppuccin_flavour 'macchiato' # or frappe, macchiato, mocha

    '';
  };

}
