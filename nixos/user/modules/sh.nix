
{ config, pkgs, ... }:
{
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
}
