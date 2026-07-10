{ pkgs }:

let
  dotfilesLib = import ../../lib { inherit pkgs; };
  
  # Temporarily pin to working nixpkgs revision for starship
  # TODO: Remove when starship 1.26.0 linker issue is fixed upstream
  oldNixpkgs = import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/e73de5be04e0eff4190a1432b946d469c794e7b4.tar.gz";
    sha256 = "04csm31wfzrhmr0qrq74gay01cbx32b7phw540j13lqdry8casx4";
  }) { inherit (pkgs) system; config.allowUnfree = true; };
in
dotfilesLib.wrapWithConfig {
  package = oldNixpkgs.starship;
  configPath = ./starship.toml;
  envVar = "STARSHIP_CONFIG";
}
