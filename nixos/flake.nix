{
  description = "My nix config";
  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
    home-manager = {
      # url = "github:nix-community/home-manager/release-23.11";
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };


   
  outputs = {self, nixpkgs, home-manager, ...} : 
    let
      lib = nixpkgs.lib;
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      # ---- SETTINGS ---- #
      #
        shared = {
          system = "x86_64-linux"; # system arch
          timezone = "Asia/Jerusalem"; # select timezone
          locale = "en_US.UTF-8"; # select locale
          username = "nazarov"
        };
        systemModules = [
          ./system/configuration.nix
        ];
        homeManagerModules = [
          ./user/home.nix
        ];
    in {
        nixosConfigurations = {
          desktop = lib.nixosSystem {
            inherit system;
            specialArgs= {
                systemSettings = {
                  inherit shared;
                  hostname = "desktop";
                  gui = true;
                };
            };
            modules = systemModules;
          };
          dev-server = lib.nixosSystem {
            inherit system;
            specialArgs= {
                systemSettings = {
                  inherit shared;
                  hostname = "dev-server";
                  gui = false;
                };
            };
            modules = systemModules; 
          };
        };
        homeConfigurations = {
          nazarov-desktop = home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            extraSpecialArgs = {
              systemSettings = {
                inherit shared;
                hostname = "desktop";
                gui = true;
              };
            };
            modules = homeManagerModules;
          };
          nazarov-dev-server= home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            extraSpecialArgs = {
              systemSettings = {
                inherit shared;
                hostname = "dev-server";
                gui = false;
              };
            };
            modules = homeManagerModules;
          };
        };
    };
}
