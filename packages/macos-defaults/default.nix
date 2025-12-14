{ pkgs }:

# macOS Defaults Package
# Manages macOS system defaults with configuration management and drift detection
#
# Provides two commands:
#   - macos-defaults: Management tool (check, list, export, discover)
#   - macos-defaults-apply: Apply configuration

let
  inherit (pkgs) lib;

  helpers = import ./lib/helpers.nix { inherit pkgs; };
  types = import ./lib/types.nix { inherit pkgs; };
  validators = import ./lib/validators.nix { inherit pkgs types; };

  # Load and validate configuration at build time
  # This will fail the build if there are validation errors
  config = validators.validationReport (import ./defaults.nix);

  # Generate apply_setting commands directly for the shell script
  # Format: apply_setting 'domain' 'key' '-type' value
  commandsForScript = lib.flatten (
    lib.mapAttrsToList (domain: settings:
      lib.mapAttrsToList (key: meta:
        let
          domainArg = helpers.escapeShellArg domain;
          keyArg = helpers.escapeShellArg key;
          typeFlag = helpers.typeToFlag meta.type;
          valueStr = helpers.valueToString meta.value meta.type;
        in
          "apply_setting ${domainArg} ${keyArg} ${typeFlag} ${valueStr}"
      ) settings
    ) config.domains
  );

  # Build apply script by substituting commands into template
  commandsText = lib.concatMapStringsSep "\n" (cmd: "    ${cmd}") commandsForScript;

  applyScript = pkgs.writeTextFile {
    name = "macos-defaults-apply";
    text = builtins.replaceStrings
      ["@COMMANDS@"]
      [commandsText]
      (builtins.readFile ./scripts/apply-defaults.sh);
    executable = true;
  };

  # Generate JSON configuration for Python management script
  configJsonStr = builtins.toJSON {
    domains = lib.mapAttrs (domain: settings:
      lib.mapAttrs (key: meta: {
        value = meta.value;
        type = meta.type;
        description = meta.description;
      }) settings
    ) config.domains;
  };

  configJson = pkgs.writeText "macos-defaults-config.json" configJsonStr;

  managementScript = pkgs.writeScriptBin "macos-defaults" ''
    #!${pkgs.python3}/bin/python3
    ${builtins.replaceStrings
      ["CONFIG_PATH_PLACEHOLDER"]
      ["${configJson}"]
      (builtins.readFile ./bin/macos-defaults.py)
    }
  '';

in
pkgs.stdenv.mkDerivation {
  name = "macos-defaults-configured";
  version = "2.0.0";

  dontUnpack = true;
  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin $out/share/macos-defaults

    cp ${configJson} $out/share/macos-defaults/config.json
    cp ${applyScript} $out/bin/macos-defaults-apply  # Already executable from writeTextFile
    cp ${managementScript}/bin/macos-defaults $out/bin/macos-defaults
  '';

  meta = {
    description = "macOS system defaults configuration and management";
    longDescription = ''
      Manages macOS system defaults with declarative configuration.

      Includes two tools:
      - macos-defaults: Check drift, list settings, export, and discover
      - macos-defaults-apply: Apply the configuration (supports DRY_RUN=1 and VERBOSE=1)

      Refactored for modularity, better error handling, and maintainability.
    '';
    platforms = lib.platforms.darwin;
    maintainers = [ ];
  };
}
