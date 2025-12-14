{ pkgs, types }:

let
  inherit (pkgs) lib;

  mkError = domain: key: message: {
    inherit domain key message;
    severity = "error";
  };

  mkWarning = domain: key: message: {
    inherit domain key message;
    severity = "warning";
  };

  # Forward declaration for recursive use
  validators = {
    validateSetting = domain: key: meta:
      let
        errors = [];

        # Check required fields
        missingValue = if !meta ? value then
          [ (mkError domain key "Missing required field 'value'") ]
        else [];

        missingType = if !meta ? type then
          [ (mkError domain key "Missing required field 'type'") ]
        else [];

        # Check type is valid
        invalidType = if meta ? type && !(types.isValidType meta.type) then
          [ (mkError domain key "Invalid type '${meta.type}'. Must be one of: ${builtins.concatStringsSep ", " types.validTypes}") ]
        else [];

        # Check value matches type (only if both value and type are present and type is valid)
        typeMismatch = if (meta ? value) && (meta ? type) && (types.isValidType meta.type) &&
                          !(types.validateValueType meta.value meta.type) then
          [ (mkError domain key "Value type mismatch: expected ${types.typeDescription meta.type}, got ${builtins.typeOf meta.value}") ]
        else [];

        # Check description exists (warning only)
        missingDescription = if !(meta ? description) || meta.description == "" then
          [ (mkWarning domain key "Missing description (recommended for documentation)") ]
        else [];

      in
        missingValue ++ missingType ++ invalidType ++ typeMismatch ++ missingDescription;

    validateConfig = config:
      let
        # Validate structure
        structureErrors =
          if !config ? domains then
            [ { domain = "ROOT"; key = ""; message = "Missing 'domains' attribute in config"; severity = "error"; } ]
          else if !builtins.isAttrs config.domains then
            [ { domain = "ROOT"; key = ""; message = "'domains' must be an attribute set"; severity = "error"; } ]
          else
            [];

        # Validate all settings if structure is valid
        settingIssues = if structureErrors == [] then
          lib.flatten (
            lib.mapAttrsToList (domain: settings:
              if !builtins.isAttrs settings then
                [ (mkError domain "" "Domain '${domain}' must be an attribute set of settings") ]
              else
                lib.flatten (
                  lib.mapAttrsToList (key: meta:
                    validators.validateSetting domain key meta
                  ) settings
                )
            ) config.domains
          )
        else
          [];

        allIssues = structureErrors ++ settingIssues;
        errors = builtins.filter (issue: issue.severity == "error") allIssues;
        warnings = builtins.filter (issue: issue.severity == "warning") allIssues;

      in {
        inherit errors warnings;
        isValid = errors == [];
        errorCount = builtins.length errors;
        warningCount = builtins.length warnings;
      };

    # Generate a human-readable validation report
    # Throws an error if validation fails, otherwise returns the config
    validationReport = config:
      let
        validation = validators.validateConfig config;

      formatIssue = issue:
        let
          location = if issue.key != "" then
            "${issue.domain}.${issue.key}"
          else if issue.domain != "" then
            issue.domain
          else
            "ROOT";
        in
          "  [${issue.severity}] ${location}: ${issue.message}";

      errorMessages = map formatIssue validation.errors;
      warningMessages = map formatIssue validation.warnings;

      report =
        if validation.errorCount > 0 then
          builtins.throw ''

            Configuration validation failed with ${toString validation.errorCount} error(s):

            ${builtins.concatStringsSep "\n" errorMessages}
            ${if validation.warningCount > 0 then
              "\n\nWarnings (${toString validation.warningCount}):\n" + builtins.concatStringsSep "\n" warningMessages
            else ""}
          ''
        else if validation.warningCount > 0 then
          builtins.trace ''
            Configuration validation warnings (${toString validation.warningCount}):
            ${builtins.concatStringsSep "\n" warningMessages}
          '' config
        else
          config;

    in report;
  };

in validators
