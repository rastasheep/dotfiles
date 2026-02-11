{ pkgs, claudePkgs }:

let
  inherit (pkgs) lib;
  dotfilesLib = import ../../lib { inherit pkgs; };

  claudeConfig = dotfilesLib.buildConfig {
    name = "claude";
    src = ./config;
  };

  # Wrapper script that handles config setup and environment
  claudeWrapper = pkgs.writeShellScriptBin "claude" ''
    # Add 1Password CLI to PATH
    export PATH="${lib.makeBinPath [ pkgs._1password-cli ]}:$PATH"

    # Ensure ~/.claude directory exists as a writable directory
    mkdir -p "$HOME/.claude"

    # Link only specific config files, not the entire directory
    # This allows Claude to create logs, cache, and other files it needs
    ${dotfilesLib.smartConfigLink {
      from = "${claudeConfig}/share/claude/settings.json";
      to = "$HOME/.claude/settings.json";
    }}

    # Sync commands: copy dotfiles commands while preserving marketplace-installed ones
    mkdir -p "$HOME/.claude/commands"

    # Remove old symlink if it exists
    if [ -L "$HOME/.claude/commands" ]; then
      rm -f "$HOME/.claude/commands"
      mkdir -p "$HOME/.claude/commands"
    fi

    # Sync our dotfiles commands (updates our files, preserves marketplace additions)
    cp -f ${claudeConfig}/share/claude/commands/* "$HOME/.claude/commands/" 2>/dev/null || true

    # Define secret references for 1Password
    export AWS_BEARER_TOKEN_BEDROCK="op://Private/claude-code/AWS_BEARER_TOKEN_BEDROCK"
    export OTEL_EXPORTER_OTLP_METRICS_ENDPOINT="op://Private/claude-code/OTEL_EXPORTER_OTLP_METRICS_ENDPOINT"
    export OTEL_EXPORTER_OTLP_HEADERS="op://Private/claude-code/OTEL_EXPORTER_OTLP_HEADERS"
    export OTEL_RESOURCE_ATTRIBUTES="op://Private/claude-code/OTEL_RESOURCE_ATTRIBUTES"
    export ANTHROPIC_DEFAULT_SONNET_MODEL="op://Private/claude-code/ANTHROPIC_DEFAULT_SONNET_MODEL"
    export ANTHROPIC_DEFAULT_HAIKU_MODEL="op://Private/claude-code/ANTHROPIC_DEFAULT_HAIKU_MODEL"
    export ANTHROPIC_DEFAULT_OPUS_MODEL="op://Private/claude-code/ANTHROPIC_DEFAULT_OPUS_MODEL"

    # Execute claude with secrets loaded via op run
    exec op run -- script -q /dev/null ${claudePkgs.claude-code}/bin/claude "$@"
  '';
in
pkgs.buildEnv {
  name = "claude-code-configured";
  paths = [
    claudeWrapper
    claudeConfig
  ];
  pathsToLink = [ "/bin" "/share" ];

  passthru = {
    unwrapped = claudePkgs.claude-code;
    version = claudePkgs.claude-code.version or "unknown";
  };

  meta = {
    description = "Claude Code with 1Password integration and custom configuration";
    homepage = "https://claude.ai/code";
    platforms = lib.platforms.darwin;
    mainProgram = "claude";
  };
}
