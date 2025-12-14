{ pkgs }:

# Helper functions for generating macOS defaults commands

let
  inherit (pkgs) lib;

  # Escape shell argument using single quotes (safe for all content)
  escapeShellArg = arg:
    let
      escaped = builtins.replaceStrings ["'"] ["'\\''"] arg;
    in "'${escaped}'";

in rec {
  # Example: "bool" -> "-bool"
  typeToFlag = type: {
    bool = "-bool";
    int = "-int";
    string = "-string";
    float = "-float";
    array = "-array";
    dict = "-dict";
  }.${type};

  # Convert value to properly escaped string for shell
  # Preserves $VAR in strings for runtime shell expansion
  valueToString = value: type:
    if type == "bool" then
      (if value then "true" else "false")
    else if type == "array" then
      # Escape JSON for shell - wrap in single quotes and escape existing quotes
      escapeShellArg (builtins.toJSON value)
    else if type == "dict" then
      # Escape dict representation for shell
      escapeShellArg (builtins.toJSON value)
    else if type == "string" then
      if builtins.match ".*\\$.*" value != null then
        # Preserve $VAR for runtime shell expansion - use double quotes
        ''"${value}"''
      else
        ''"${value}"''
    else
      toString value;

  # Export escapeShellArg for use in default.nix
  inherit escapeShellArg;
}
