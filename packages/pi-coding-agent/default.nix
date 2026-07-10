{ pkgs, claudePkgs }:

let
  inherit (pkgs) lib;
  dotfilesLib = import ../../lib { inherit pkgs; };

  piConfig = dotfilesLib.buildConfig {
    name = "pi";
    src = ./config;
  };

  # Install pi-coding-agent using bun
  piPackage = pkgs.stdenvNoCC.mkDerivation {
    name = "pi-coding-agent";
    version = "0.80.6";

    nativeBuildInputs = [ pkgs.bun pkgs.makeWrapper ];

    unpackPhase = "true";

    buildPhase = ''
      export HOME=$TMPDIR
      mkdir -p $HOME

      # Install the package locally
      ${pkgs.bun}/bin/bun install --no-save @earendil-works/pi-coding-agent
    '';

    installPhase = ''
      mkdir -p $out/lib
      cp -r node_modules $out/lib/

      # Create wrapper script
      mkdir -p $out/bin
      makeWrapper ${pkgs.bun}/bin/bun $out/bin/pi \
        --set NODE_PATH "$out/lib/node_modules" \
        --add-flags "$out/lib/node_modules/@earendil-works/pi-coding-agent/dist/cli.js"
    '';

    meta = {
      description = "Pi - minimal terminal coding harness";
      homepage = "https://github.com/earendil-works/pi-mono";
      platforms = lib.platforms.unix;
    };
  };

  # Common setup for both modes
  commonSetup = ''
    set -euo pipefail

    # Add 1Password CLI and bun to PATH
    export PATH="${lib.makeBinPath [ pkgs._1password-cli pkgs.bun ]}:$PATH"

    # Ensure ~/.pi/agent directory exists as a writable directory
    mkdir -p "$HOME/.pi/agent"

    # Link AGENTS.md (only if it doesn't exist or is a symlink)
    if [ ! -e "$HOME/.pi/agent/AGENTS.md" ] || [ -L "$HOME/.pi/agent/AGENTS.md" ]; then
      ln -sf "${piConfig}/share/pi/agent/AGENTS.md" "$HOME/.pi/agent/AGENTS.md"
    fi

    # Sync extensions (preserves user-added extensions)
    mkdir -p "$HOME/.pi/agent/extensions"
    if [ -d "${piConfig}/share/pi/extensions" ]; then
      cp -f "${piConfig}/share/pi/extensions"/*.ts "$HOME/.pi/agent/extensions/" 2>/dev/null || true
      cp -f "${piConfig}/share/pi/extensions"/*.md "$HOME/.pi/agent/extensions/" 2>/dev/null || true
    fi

    # Sync subagent extension (multi-file structure)
    if [ -d "${piConfig}/share/pi/extensions/subagent" ]; then
      mkdir -p "$HOME/.pi/agent/extensions/subagent"
      cp -f "${piConfig}/share/pi/extensions/subagent"/*.ts "$HOME/.pi/agent/extensions/subagent/" 2>/dev/null || true
    fi

    # Sync agent definitions (user can add their own)
    if [ -d "${piConfig}/share/pi/agent/agents" ]; then
      mkdir -p "$HOME/.pi/agent/agents"
      cp -f "${piConfig}/share/pi/agent/agents"/*.md "$HOME/.pi/agent/agents/" 2>/dev/null || true
    fi

    # Sync workflow prompts
    if [ -d "${piConfig}/share/pi/prompts" ]; then
      mkdir -p "$HOME/.pi/agent/prompts"
      cp -f "${piConfig}/share/pi/prompts"/*.md "$HOME/.pi/agent/prompts/" 2>/dev/null || true
    fi
  '';

  # Pure mode wrapper (manual API key setup)
  piPureWrapper = pkgs.writeShellScriptBin "pi" ''
    ${commonSetup}

    # Execute pi without AWS/Bedrock setup
    exec ${piPackage}/bin/pi "$@"
  '';

  # AWS Bedrock wrapper (with 1Password credentials)
  piAwsWrapper = pkgs.writeShellScriptBin "pi-aws" ''
    ${commonSetup}

    # AWS Bedrock configuration from 1Password
    export AWS_REGION="us-east-1"
    export PI_CACHE_RETENTION="long"
    export AWS_BEDROCK_FORCE_CACHE="1"
    export AWS_ACCESS_KEY_ID="op://Private/claude-code-2/AWS_ACCESS_KEY_ID"
    export AWS_SECRET_ACCESS_KEY="op://Private/claude-code-2/AWS_SECRET_ACCESS_KEY"

    # Execute pi with 1Password secrets loaded via op run.
    # op run pipes stdout to scan for secrets, which makes pi see a non-TTY
    # stdout and fall back to non-interactive print mode. script allocates a
    # pseudo-TTY so pi still detects an interactive terminal (same fix as claude-code).
    # Set favorite models for Ctrl+P cycling (cross-region inference profile IDs,
    # required since this AWS account has no direct on-demand model access)
    exec op run -- script -q /dev/null ${piPackage}/bin/pi \
      --provider amazon-bedrock \
      --models "us.anthropic.claude-sonnet-5,us.anthropic.claude-opus-4-8,us.anthropic.claude-haiku-4-5-20251001-v1:0" \
      "$@"
  '';
in
pkgs.buildEnv {
  name = "pi-coding-agent-configured";
  paths = [
    piPureWrapper
    piAwsWrapper
    piConfig
  ];
  pathsToLink = [ "/bin" "/share" ];

  passthru = {
    unwrapped = piPackage;
    version = piPackage.version or "unknown";
  };

  meta = {
    description = "Pi coding agent with pure and AWS Bedrock modes";
    homepage = "https://github.com/earendil-works/pi-mono";
    platforms = lib.platforms.unix;
    mainProgram = "pi";
  };
}
