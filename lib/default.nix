{ pkgs }:

# Shared utilities for dotfiles packages
# Provides consistent patterns for wrapping, config building, and metadata

let
  inherit (pkgs) lib;
in
rec {
  # Standard wrapper for CLI tools with configuration files
  # Wraps a package and sets an environment variable pointing to config
  #
  # Example:
  #   wrapWithConfig {
  #     package = pkgs.starship;
  #     configPath = ./starship.toml;
  #     envVar = "STARSHIP_CONFIG";
  #   }
  wrapWithConfig = { package, configPath, envVar ? "CONFIG_FILE" }:
    pkgs.symlinkJoin {
      name = "${package.pname or package.name}-configured";
      paths = [ package ];
      buildInputs = [ pkgs.makeWrapper ];

      postBuild = ''
        for bin in $out/bin/*; do
          wrapProgram "$bin" --set ${envVar} ${configPath}
        done
      '';

      passthru = {
        unwrapped = package;
        version = package.version or "unknown";
      };

      meta = package.meta or {};
    };

  # Standard config directory builder
  # Creates a derivation that installs config files to /share/{name}
  #
  # Example:
  #   buildConfig {
  #     name = "ghostty";
  #     src = ./config;
  #   }
  buildConfig = { name, src, subdir ? "" }:
    pkgs.stdenvNoCC.mkDerivation {
      inherit name src;
      dontBuild = true;

      installPhase = ''
        mkdir -p $out/share/${name}
        ${if subdir != "" then
          "cp -r $src/${subdir}/* $out/share/${name}/"
        else
          "cp -r $src/* $out/share/${name}/"
        }
      '';
    };

  # Smart config symlinker - backs up real files/dirs, replaces symlinks
  # Returns shell script snippet for use in wrapper postBuild
  #
  # Example:
  #   smartConfigLink {
  #     from = "${config}/share/ghostty";
  #     to = "$HOME/.config/ghostty";
  #   }
  smartConfigLink = { from, to }:
    ''
      # Smart config linking: backup real files, replace symlinks
      if [ -e "${to}" ] && [ ! -L "${to}" ]; then
        # It's a real file/directory, not a symlink - back it up
        backup="${to}.backup.$(date +%Y%m%d-%H%M%S)"
        echo "Backing up existing config to $backup" >&2
        mv "${to}" "$backup"
      fi
      # Create/update symlink (replaces old symlinks, creates new ones)
      ln -sf ${from} "${to}"
    '';

  # Standard meta attributes template for macOS packages
  # Filters out null values automatically
  #
  # Example:
  #   mkMeta {
  #     description = "My awesome tool";
  #     homepage = "https://example.com";
  #     license = lib.licenses.mit;
  #     mainProgram = "mytool";
  #   }
  mkMeta = { description, homepage ? null, license ? null, mainProgram ? null }:
    lib.filterAttrs (_: v: v != null) {
      inherit description;
      platforms = lib.platforms.darwin;
      homepage = homepage;
      license = license;
      mainProgram = mainProgram;
    };
}
