
{ config, pkgs, ... }:
let
  configDirs = [
    ".gitconfig"
    ".ssh/config"
    ".tmuxinator"
    ".config/bat"
    ".config/btop"
    ".config/Code"
    ".config/hypr"
    ".config/kitty"
    ".config/lvim"
    ".config/nvim"
    ".config/starship"
    ".config/swaync"
    ".config/tofi"
    ".config/waybar"
    ".config/yazi"
    ".config/zsh"
  ];
in
{
  
  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.

  home.file = builtins.listToAttrs (map (dir: {
    name = dir;
    value = { 
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/${dir}"; 
    };
  }) configDirs) // {
    "Projects/Personal/.keep".text = "";
    "Projects/Yoobic/.keep".text = "";
    "Downloads/Work/.keep".text = "";
    "Downloads/Scetch/.keep".text = "";
    "Screenshots/.keep".text = "";
  };

}
    
