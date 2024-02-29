{
  description = "My nix config";
  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
  };
  outputs = {self, nixpkgs, ...} : 
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
          inherit system;
          config ={
            allowUnfree = true;
          };
        };
    in {
        nixosConfigurations = {
          desktop = nixpkgs.lib.nixosSystem {
            inherit system;
            modules = [
              ./system/configuration.nix
            ];
          };
        };
    };
}
