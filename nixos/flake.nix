{
  description = "My nix config";
  inputs = {
    zen-browser.url = "github:0xc000022070/zen-browser-flake";

    nixpkgs-unstable = {
     url = "github:NixOS/nixpkgs/nixos-unstable";
    };
    nixpkgs = {
      url = "github:NixOS/nixpkgs/release-24.05";
      #url = "github:NixOS/nixpkgs/release-23.11";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      #url = "github:nix-community/home-manager/master";
      #url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };


   
  outputs = {self, nixpkgs, nixpkgs-unstable, home-manager, zen-browser, ...} : 
    let
      lib = nixpkgs.lib;
      system = "x86_64-linux";
      flakePackages = {
           zen-browser = zen-browser;
        };
      pkgs = import nixpkgs  {
        system = "x86_64-linux";
	config.allowUnfree = true;
      };
      # ---- SETTINGS ---- #
      #
        shared = {
          system = "x86_64-linux"; # system arch
          timezone = "Asia/Jerusalem"; # select timezone
          locale = "en_GB.UTF-8"; # select locale
          username = "nazarov";
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
                flakePackages = flakePackages;
                pkgs-unstable = import nixpkgs-unstable {
                 inherit system;
                  config.allowUnfree = true;
                };
            };
            modules = systemModules;
          };
          matebook = lib.nixosSystem {
            inherit system;
            specialArgs= {
                systemSettings = {
                  inherit shared;
                  hostname = "matebook";
                  gui = true;
                };
                flakePackages = flakePackages;

                pkgs-unstable = import nixpkgs-unstable {
                 inherit system;
                  config.allowUnfree = true;
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
                flakePackages = flakePackages;
                pkgs-unstable = import nixpkgs-unstable {
                 inherit system;
                  config.allowUnfree = true;
                };
            };
            modules = systemModules; 
          };
          home-server = lib.nixosSystem {
            inherit system;
            specialArgs= {
                systemSettings = {
                  inherit shared;
                  hostname = "home-server";
                  gui = true;
                };
                flakePackages = flakePackages;
                pkgs-unstable = import nixpkgs-unstable {
                 inherit system;
                  config.allowUnfree = true;
                };
            };
            modules = systemModules; 
          };
          
        };
        homeConfigurations = {
          "nazarov@desktop" = home-manager.lib.homeManagerConfiguration {
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
          "nazarov@matebook" = home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            extraSpecialArgs = {
              systemSettings = {
                inherit shared;
                hostname = "matebook";
                gui = true;
              };
            };
            modules = homeManagerModules;
          };
          "nazarov@dev-server"= home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            extraSpecialArgs = {
              systemSettings = {
                inherit shared;
                hostname = "dev-server";
                gui = false;
              };
            };
          };
          "nazarov@home-server"= home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            extraSpecialArgs = {
              systemSettings = {
                inherit shared;
                hostname = "home-server";
                gui = false;
              };
            };
            modules = homeManagerModules;
          };
        };
    };
}
