{
  description = "Fleek Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    claude-nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, home-manager, claude-nixpkgs, ... }@inputs: 
    let
      system = "aarch64-darwin";
      claudePkgs = import claude-nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in {
    # Available through 'home-manager --flake .#your-username@your-hostname'

    homeConfigurations = {
      "rastasheep@aleksandars-mbp" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system}; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = { inherit inputs; }; # Pass flake inputs to our config
        modules = [
          ./home.nix
          ./aleksandars-mbp/rastasheep.nix
          ({
           nixpkgs.overlays = [
               (final: prev: {
                   blender = final.callPackage ./pkgs/blender.nix {};
                   kicad = final.callPackage ./pkgs/kicad.nix {};
                   hammerspoon = final.callPackage ./pkgs/hammerspoon.nix {};
                   claude-code = final.symlinkJoin {
                     name = "claude-code-wrapped";
                     paths = [ claudePkgs.claude-code ];
                     buildInputs = [ final.makeWrapper ];
                     postBuild = ''
                       for bin in $out/bin/*; do
                         wrapProgram "$bin" \
                           --prefix PATH : ${final.lib.makeBinPath [ final._1password-cli ]} \
                           --run 'export AWS_BEARER_TOKEN_BEDROCK=$(op read "op://Private/claude-code/AWS_BEARER_TOKEN_BEDROCK")' \
                           --run 'export OTEL_EXPORTER_OTLP_METRICS_ENDPOINT=$(op read "op://Private/claude-code/OTEL_EXPORTER_OTLP_METRICS_ENDPOINT")' \
                           --run 'export OTEL_EXPORTER_OTLP_HEADERS=$(op read "op://Private/claude-code/OTEL_EXPORTER_OTLP_HEADERS")' \
                           --run 'export OTEL_RESOURCE_ATTRIBUTES=$(op read "op://Private/claude-code/OTEL_RESOURCE_ATTRIBUTES")'
                       done
                     '';
                   };
               })
           ];
          })

        ];
      };
    };
  };
}
