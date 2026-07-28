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
          # `|| true`: apply_setting already tallies SUCCESS_COUNT/FAIL_COUNT
          # and returns non-zero on failure; without this, set -e (in
          # apply-defaults.sh) would abort the whole script on the first
          # failing setting, silently skipping every setting listed after it.
          "apply_setting ${domainArg} ${keyArg} ${typeFlag} ${valueStr} || true"
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

  # Keyboard remapping (hidutil + LaunchAgent), separate from the `defaults
  # write` settings above since it's a different mechanism entirely.
  keyboardRemapConfig = import ./keyboard-remaps.nix;
  keyboardRemapLib = import ./lib/keyboard-remap.nix { inherit pkgs; };

  userKeyMappingJson = keyboardRemapLib.buildUserKeyMappingJson keyboardRemapConfig.mappings;

  keyboardRemapPlist = pkgs.writeText "${keyboardRemapConfig.label}.plist" (
    keyboardRemapLib.buildLaunchAgentPlist {
      label = keyboardRemapConfig.label;
      inherit userKeyMappingJson;
    }
  );

  keyboardRemapApplyScript = pkgs.writeTextFile {
    name = "keyboard-remap-apply";
    text = builtins.replaceStrings
      ["@LABEL@" "@PLIST_SRC@"]
      [keyboardRemapConfig.label "${keyboardRemapPlist}"]
      (builtins.readFile ./scripts/apply-keyboard-remap.sh);
    executable = true;
  };

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

    cp ${keyboardRemapPlist} $out/share/macos-defaults/${keyboardRemapConfig.label}.plist
    cp ${keyboardRemapApplyScript} $out/bin/keyboard-remap-apply  # Already executable from writeTextFile
  '';

  # Consumed by lib.mkDotfilesApply: both commands only take effect if
  # re-run after every profile upgrade (defaults writes and the LaunchAgent
  # plist aren't managed by `nix profile upgrade` itself), and both are
  # idempotent so it's safe to run them on every `dotfiles-apply`.
  passthru.activationCommand = "macos-defaults-apply && keyboard-remap-apply";

  meta = {
    description = "macOS system defaults configuration and management";
    longDescription = ''
      Manages macOS system defaults with declarative configuration.

      Includes three tools:
      - macos-defaults: Check drift, list settings, export, and discover
      - macos-defaults-apply: Apply the `defaults write` configuration (supports DRY_RUN=1 and VERBOSE=1)
      - keyboard-remap-apply: Install and load the hidutil keyboard remap LaunchAgent (see keyboard-remaps.nix)

      Refactored for modularity, better error handling, and maintainability.
    '';
    homepage = "https://github.com/rastasheep/dotfiles";
    platforms = lib.platforms.darwin;
    maintainers = [ ];
    mainProgram = "macos-defaults";
  };
}
