
{ config, pkgs, ... }:
{

  # The home.packages option allows you to install Nix packages into your
  # environment.
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
      set -g default-terminal "xterm-256color"
      set-option -ga terminal-overrides ",xterm-256color:Tc"
      #set -ga terminal-overrides ",*256col*:Tc"
      #set -ga terminal-overrides '*:Ss=\E[%p1%d q:Se=\E[ q'
      #set-environment -g COLORTERM "truecolor"

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
  home.packages = with pkgs; [
      # Fonts 
     (nerdfonts.override { fonts = [ "FiraCode" ]; })
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
      # Programming language
      jre8
      python3
      ruby
      go
      nodejs_20
      bun
      nodePackages.neovim
        #nodePackages.yarn
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


    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];
}
