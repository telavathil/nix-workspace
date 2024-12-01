{
  description = "Personal macOS workspace configuration using nix-darwin and Home Manager";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    
    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nix-darwin
    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, darwin, ... }@inputs:
    let
      system = "aarch64-darwin";  # For Apple Silicon, use "x86_64-darwin" for Intel Macs
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      darwinConfigurations."laptop" = darwin.lib.darwinSystem {
        inherit system;
        modules = [
          ./hosts/laptop/configuration.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.tobin = import ./home.nix;
          }
        ];
        specialArgs = { inherit inputs; };
      };
    };
}
