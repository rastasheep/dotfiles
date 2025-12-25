{ pkgs }:

let
  dotfilesLib = import ../../lib { inherit pkgs; };
in
dotfilesLib.wrapWithConfig {
  package = pkgs.starship;
  configPath = ./starship.toml;
  envVar = "STARSHIP_CONFIG";
}
