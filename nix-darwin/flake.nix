{
  description = "Example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs }:
  let
    configuration = { pkgs, ... }: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      # fonts.packages = with pkgs; [
      #   (nerdfonts.override { fonts = [ "FiraCode" ]; })
      # ];

      homebrew = {
          enable = true;
          brews = [
            "libomp"
            "zlib"
            "pyenv"
            "choose-gui"
            "doppler"
            "gs"
            "make"
            "pkg-config"
            "gcc" 
            "sheldon" 
            "stow"
            "lf"
            "eza" 
            "bat" 
            "fzf" 
            "rg"
            "fd"
            "xclip" 
            "procs" 
            "btop"
            "neovim"
            "lazygit" 
            "ripgrep" 
            "yazi"
            "moreutils"
            "rbenv"
            "ruby-build"
            "fnm"
            "starship"
            "dust"
            "gh"
            "shortcat"
          ];
      casks = [
            "kitty"
            "raycast"
            "docker"
            "anydesk"
            "slack"
            "studio-3t"
            "google-cloud-sdk"
            "scroll-reverser" 
            "zen-browser"
            "karabiner-elements"

          ];
      };

      services = {
          skhd.enable = true;
          yabai.enable = true;
      };
      environment.systemPackages =
        [ 
          pkgs.nerd-fonts.fira-code  
          # pkgs.vim
          # pkgs.cowsay

        ];

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Add the new WindowManager setting
      system.defaults = {
        WindowManager = {
          EnableStandardClickToShowDesktop = false; # true = Always, false = Only in Stage Manager
        };
      };


      # Enable alternative shell support in nix-darwin.
      # programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#Petrs-MacBook-Air
    darwinConfigurations."Petrs-MacBook-Air" = nix-darwin.lib.darwinSystem {
      modules = [ configuration ];
    };
  };
}
