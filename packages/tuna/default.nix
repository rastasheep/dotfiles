{ pkgs }:

let
  inherit (pkgs) lib;
  dotfilesLib = import ../../lib { inherit pkgs; };

  # NOTE: This is a placeholder package for Tuna configuration tracking.
  #
  # Tuna.app is installed manually from https://tunaformac.com/download/latest
  # The config template stored here serves as reference/bootstrap only.
  #
  # Why no automation?
  # - Nix builds run in sandbox without $HOME access
  # - No post-install hooks available for `nix profile upgrade`
  # - Automatic syncing requires manual wrapper scripts
  #
  # Workflow:
  # 1. Use Tuna normally, settings saved to ~/Library/Application Support/Tuna/config.toml
  # 2. When ready to commit changes:
  #    cp ~/Library/Application\ Support/Tuna/config.toml packages/tuna/config/
  #    git add packages/tuna/config/ && git commit -m "feat(tuna): update config"

  tunaConfig = dotfilesLib.buildConfig {
    name = "tuna";
    src = ./config;
  };

in
pkgs.buildEnv {
  name = "tuna-placeholder";
  paths = [ tunaConfig ];
  pathsToLink = [ "/share" ];

  meta = {
    description = "Tuna config template (app installed manually, see default.nix for workflow)";
    homepage = "https://tunaformac.com";
    platforms = lib.platforms.darwin;
  };
}
