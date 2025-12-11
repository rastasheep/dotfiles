{ pkgs, claudePkgs }:

let
  claudeConfig = pkgs.stdenvNoCC.mkDerivation {
    name = "claude-config";
    src = ./config;

    installPhase = ''
      mkdir -p $out/share/claude
      cp -r $src/* $out/share/claude/
    '';
  };

  claudeWrapped = pkgs.symlinkJoin {
    name = "claude-code-wrapped";
    paths = [ claudePkgs.claude-code ];
    buildInputs = [ pkgs.makeWrapper ];

    postBuild = ''
      for bin in $out/bin/*; do
        wrapProgram "$bin" \
          --prefix PATH : ${pkgs.lib.makeBinPath [ pkgs._1password-cli ]} \
          --run '
            # Smart config linking: backup real files, replace symlinks
            if [ -e "$HOME/.claude" ] && [ ! -L "$HOME/.claude" ]; then
              backup="$HOME/.claude.backup.$(date +%Y%m%d-%H%M%S)"
              echo "Backing up existing Claude config to $backup" >&2
              mv "$HOME/.claude" "$backup"
            fi
            ln -sf ${claudeConfig}/share/claude "$HOME/.claude"
          ' \
          --run 'export AWS_BEARER_TOKEN_BEDROCK=$(op read "op://Private/claude-code/AWS_BEARER_TOKEN_BEDROCK" 2>/dev/null || true)' \
          --run 'export OTEL_EXPORTER_OTLP_METRICS_ENDPOINT=$(op read "op://Private/claude-code/OTEL_EXPORTER_OTLP_METRICS_ENDPOINT" 2>/dev/null || true)' \
          --run 'export OTEL_EXPORTER_OTLP_HEADERS=$(op read "op://Private/claude-code/OTEL_EXPORTER_OTLP_HEADERS" 2>/dev/null || true)' \
          --run 'export OTEL_RESOURCE_ATTRIBUTES=$(op read "op://Private/claude-code/OTEL_RESOURCE_ATTRIBUTES" 2>/dev/null || true)'
      done
    '';
  };
in
pkgs.buildEnv {
  name = "claude-code-configured";
  paths = [
    claudeWrapped
    claudeConfig
  ];
  pathsToLink = [ "/bin" "/share" ];

  meta = {
    description = "Claude Code with 1Password integration and custom configuration";
    mainProgram = "claude";
  };
}
