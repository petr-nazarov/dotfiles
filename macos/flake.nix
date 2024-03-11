{
  description = "Macos setup";
  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/release-23.11";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      #url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:ln17/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    }



  };
  outputs = inputs :{
    let
        system = "x86_64-darwin";
    in {
      darwinConfigurations = inputs.darwin.lib.darwinSystem {
        inherit system;
        pkgs = import inputs.nixpkgs {
          inherit system;
        };
      };
      modules = [
        ({pkgs, ...}:{
          programs.zsh.enable = true;
          enviroment.shells = [pkgs.bash pkgs.zsh ];
          enviroment.loginShell = pkgs.zsh;
          nix.extraOptions = ''
            experimental-features = nix-command flakes
          '';
          system.keyboard.enableKeyMapping = true;
          system.keyboard.remapCapsLockToEscape = true;
          services.nix-daemon.enable = true;

        })
      ];
    };
  };
}
