{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfreePredicate = (_: true);
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "nazarov";
  home.homeDirectory = "/home/nazarov";
  

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
      # Fonts 
     (pkgs.nerdfonts.override { fonts = [ "FiraCode" ]; })
      # Command line utilities
      unzip
      unrar
      poppler
      zsh
      antidote
      starship
      stow
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
      #TUI programs
      tmux
      tmuxinator
      vim
      neovim
      lunarvim
      lazygit
      yazi
      # GUI programs
      robo3t
      cinnamon.nemo-with-extensions
      brave
      kitty
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

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    zplug = {
      enable = true;
      plugins = [
        { name = "zsh-users/zsh-autosuggestions"; } # Simple plugin installation
        { name = "plugins/colored-man-pages"; tags = ["from:oh-my-zsh"]; }
        { name = "plugins/command-not-found"; tags = ["from:oh-my-zsh"]; }
        { name = "unixorn/fzf-zsh-plugin"; }
        { name = "Aloxaf/fzf-tab"; }
        { name = "zsh-users/zsh-completions"; }
        { name = "zsh-users/zsh-autosuggestions"; }
        { name = "zsh-users/zsh-syntax-highlighting"; }
      ];
    };
    initExtra = ''
### Paths ###
source $HOME/.config/zsh/paths.zsh

### Plugins ###
source $HOME/.config/zsh/plugins.zsh

### Theme ###
source $HOME/.config/zsh/theme.zsh

### Aliases ###
source $HOME/.config/zsh/aliases.zsh

### Variables ###
source $HOME/.config/zsh/variables.zsh

### Secrets ###

if [ -d $HOME/.secrets ]
then
  source $HOME/.secrets/secrets.zsh
fi
### Key Binds ###
source $HOME/.config/zsh/bind-keys.zsh


    '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/nazarov/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
