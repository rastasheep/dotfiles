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
    version = "0.67.68";

    nativeBuildInputs = [ pkgs.bun pkgs.makeWrapper ];

    unpackPhase = "true";

    buildPhase = ''
      export HOME=$TMPDIR
      mkdir -p $HOME

      # Install the package locally
      ${pkgs.bun}/bin/bun install --no-save @mariozechner/pi-coding-agent
    '';

    installPhase = ''
      mkdir -p $out/lib
      cp -r node_modules $out/lib/

      # Create wrapper script
      mkdir -p $out/bin
      makeWrapper ${pkgs.bun}/bin/bun $out/bin/pi \
        --set NODE_PATH "$out/lib/node_modules" \
        --add-flags "$out/lib/node_modules/@mariozechner/pi-coding-agent/dist/cli.js"
    '';

    meta = {
      description = "Pi - minimal terminal coding harness";
      homepage = "https://shittycodingagent.ai/";
      platforms = lib.platforms.unix;
    };
  };

  # Wrapper script that handles config setup and environment
  piWrapper = pkgs.writeShellScriptBin "pi" ''
    set -euo pipefail

    # Add 1Password CLI and bun to PATH
    export PATH="${lib.makeBinPath [ pkgs._1password-cli pkgs.bun ]}:$PATH"

    # Ensure ~/.pi/agent directory exists as a writable directory
    mkdir -p "$HOME/.pi/agent"

    # Generate models.json with ARNs from 1Password (overwrite each time)
    # op inject resolves op:// references in the template file
    if ! op inject -i "${piConfig}/share/pi/models.json" -o "$HOME/.pi/agent/models.json" -f; then
      echo "Error: Failed to inject model ARNs from 1Password" >&2
      exit 1
    fi

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

    # Pi environment configuration
    export AWS_REGION="us-east-1"
    export AWS_BEDROCK_SKIP_AUTH="1"
    export PI_CACHE_RETENTION="long"
    export AWS_BEDROCK_FORCE_CACHE="1"

    # Load bearer token from 1Password for runtime
    if ! AWS_BEARER_TOKEN_BEDROCK=$(op read "op://Private/claude-code/AWS_BEARER_TOKEN_BEDROCK"); then
      echo "Error: Failed to read bearer token from 1Password" >&2
      exit 1
    fi
    export AWS_BEARER_TOKEN_BEDROCK

    # Execute pi directly (not through op run) to preserve TTY
    # Set favorite models for Ctrl+P cycling (only your 3 bedrock models)
    exec ${piPackage}/bin/pi \
      --provider bedrock \
      --models "Claude Sonnet (Bedrock),Claude Opus (Bedrock),Claude Haiku (Bedrock)" \
      "$@"
  '';
in
pkgs.buildEnv {
  name = "pi-coding-agent-configured";
  paths = [
    piWrapper
    piConfig
  ];
  pathsToLink = [ "/bin" "/share" ];

  passthru = {
    unwrapped = piPackage;
    version = piPackage.version or "unknown";
  };

  meta = {
    description = "Pi coding agent with 1Password integration and Bedrock configuration";
    homepage = "https://shittycodingagent.ai/";
    platforms = lib.platforms.unix;
    mainProgram = "pi";
  };
}
