{ pkgs, claudePkgs }:

let
  inherit (pkgs) lib;
  dotfilesLib = import ../../lib { inherit pkgs; };

  piConfig = dotfilesLib.buildConfig {
    name = "pi";
    src = ./config;
  };

  piVersion = "1.5.2";

  # Install pi-coding-agent using bun
  piPackage = pkgs.stdenvNoCC.mkDerivation {
    name = "pi-coding-agent";
    version = piVersion;

    nativeBuildInputs = [ pkgs.bun pkgs.makeWrapper ];

    unpackPhase = "true";

    buildPhase = ''
      export HOME=$TMPDIR
      mkdir -p $HOME

      # Install the package locally
      ${pkgs.bun}/bin/bun install --no-save @earendil-works/pi-coding-agent@${piVersion}
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

  # Config sync, run on every launch
  commonSetup = ''
    set -euo pipefail

    # Add bun to PATH
    export PATH="${lib.makeBinPath [ pkgs.bun ]}:$PATH"

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

  # Provider and API key are set up interactively inside pi
  piWrapper = pkgs.writeShellScriptBin "pi" ''
    ${commonSetup}

    exec ${piPackage}/bin/pi "$@"
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
    description = "Pi coding agent with custom config";
    homepage = "https://github.com/earendil-works/pi-mono";
    platforms = lib.platforms.unix;
    mainProgram = "pi";
  };
}
