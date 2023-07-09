{
  description = "Fleek Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    # Available through 'home-manager --flake .#your-username@your-hostname'

    homeConfigurations = {
      "rastasheep@aleksandars-mbp" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.aarch64-darwin; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = { inherit inputs; }; # Pass flake inputs to our config
        modules = [
          ./home.nix
          ./aleksandars-mbp/rastasheep.nix
          ({
           nixpkgs.overlays = [
               (final: prev: {
                   arc = final.callPackage ./pkgs/arc.nix {};
                   blender = final.callPackage ./pkgs/blender.nix {};
               })
           ];
          })

        ];
      };
    };
  };
}
