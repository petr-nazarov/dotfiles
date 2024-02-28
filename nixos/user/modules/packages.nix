
{ config, pkgs, ... }:
{
  # The home.packages option allows you to install Nix packages into your
  # environment.
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
      # TUI programs
      tmux
      tmuxinator
      vim
      neovim
      lunarvim
      lazygit
      yazi
      # GUI essentials
      rofi-wayland
      waybar
      wl-clipboard
      swww # wallpaper manager
      cliphist
      pipewire wireplumber
      grim slurp grimblast # Screenshots

      # GUI programs
      cinnamon.nemo-with-extensions
      kitty
      robo3t
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
