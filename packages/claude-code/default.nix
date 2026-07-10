{ pkgs, claudePkgs }:

let
  inherit (pkgs) lib;
  dotfilesLib = import ../../lib { inherit pkgs; };

  claudeConfig = dotfilesLib.buildConfig {
    name = "claude";
    src = ./config;
  };

  # Common setup for both modes
  commonSetup = ''
    # Ensure ~/.claude directory exists as a writable directory
    mkdir -p "$HOME/.claude"

    # Link only specific config files
    ${dotfilesLib.smartConfigLink {
      from = "${claudeConfig}/share/claude/settings.json";
      to = "$HOME/.claude/settings.json";
    }}

    # Link global CLAUDE.md instructions
    ${dotfilesLib.smartConfigLink {
      from = "${claudeConfig}/share/claude/CLAUDE.md";
      to = "$HOME/.claude/CLAUDE.md";
    }}

    # Sync commands: copy dotfiles commands while preserving marketplace-installed ones
    mkdir -p "$HOME/.claude/commands"
    if [ -L "$HOME/.claude/commands" ]; then
      rm -f "$HOME/.claude/commands"
      mkdir -p "$HOME/.claude/commands"
    fi
    cp -f ${claudeConfig}/share/claude/commands/* "$HOME/.claude/commands/" 2>/dev/null || true

    # Sync skills: copy dotfiles skills while preserving marketplace-installed ones
    mkdir -p "$HOME/.claude/skills"
    if [ -L "$HOME/.claude/skills" ]; then
      rm -f "$HOME/.claude/skills"
      mkdir -p "$HOME/.claude/skills"
    fi
    if [ -d "${claudeConfig}/share/claude/skills" ]; then
      cp -rf ${claudeConfig}/share/claude/skills/* "$HOME/.claude/skills/" 2>/dev/null || true
    fi

    # Add 1Password CLI to PATH
    export PATH="${lib.makeBinPath [ pkgs._1password-cli ]}:$PATH"

    # Telemetry configuration from 1Password (common to both modes)
    export CLAUDE_CODE_ENABLE_TELEMETRY="1"
    export OTEL_METRICS_EXPORTER="otlp"
    export OTEL_EXPORTER_OTLP_PROTOCOL="http/json"
    export OTEL_EXPORTER_OTLP_METRICS_ENDPOINT="op://Private/claude-code-2/OTEL_EXPORTER_OTLP_METRICS_ENDPOINT"
    export OTEL_EXPORTER_OTLP_HEADERS="op://Private/claude-code-2/OTEL_EXPORTER_OTLP_HEADERS"
    export OTEL_RESOURCE_ATTRIBUTES="op://Private/claude-code-2/OTEL_RESOURCE_ATTRIBUTES"
  '';

  # Pure mode wrapper (manual login via Claude UI)
  claudePureWrapper = pkgs.writeShellScriptBin "claude" ''
    ${commonSetup}

    # Execute claude with 1Password telemetry secrets loaded
    exec op run -- script -q /dev/null ${claudePkgs.claude-code}/bin/claude "$@"
  '';

  # AWS Bedrock wrapper (with 1Password credentials)
  claudeAwsWrapper = pkgs.writeShellScriptBin "claude-aws" ''
    ${commonSetup}

    # AWS Bedrock configuration from 1Password
    export CLAUDE_CODE_USE_BEDROCK="true"
    export AWS_REGION="us-east-1"
    export AWS_ACCESS_KEY_ID="op://Private/claude-code-2/AWS_ACCESS_KEY_ID"
    export AWS_SECRET_ACCESS_KEY="op://Private/claude-code-2/AWS_SECRET_ACCESS_KEY"

    export ANTHROPIC_DEFAULT_SONNET_MODEL="op://Private/claude-code-2/ANTHROPIC_DEFAULT_SONNET_MODEL"
    export ANTHROPIC_DEFAULT_HAIKU_MODEL="op://Private/claude-code-2/ANTHROPIC_DEFAULT_HAIKU_MODEL"
    export ANTHROPIC_DEFAULT_OPUS_MODEL="op://Private/claude-code-2/ANTHROPIC_DEFAULT_OPUS_MODEL"

    # Execute claude with secrets loaded via op run
    exec op run -- script -q /dev/null ${claudePkgs.claude-code}/bin/claude "$@"
  '';
in
pkgs.buildEnv {
  name = "claude-code-configured";
  paths = [
    claudePureWrapper
    claudeAwsWrapper
    claudeConfig
  ];
  pathsToLink = [ "/bin" "/share" ];

  passthru = {
    unwrapped = claudePkgs.claude-code;
    version = claudePkgs.claude-code.version or "unknown";
  };

  meta = {
    description = "Claude Code with pure and AWS Bedrock modes";
    homepage = "https://claude.ai/code";
    platforms = lib.platforms.darwin;
    mainProgram = "claude";
  };
}
