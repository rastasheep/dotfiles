{ pkgs, claudePkgs }:

let
  inherit (pkgs) lib;
  dotfilesLib = import ../../lib { inherit pkgs; };

  claudeConfig = dotfilesLib.buildConfig {
    name = "claude";
    src = ./config;
  };

  claudeWrapped = pkgs.symlinkJoin {
    name = "claude-code-configured";
    paths = [ claudePkgs.claude-code ];
    buildInputs = [ pkgs.makeWrapper ];

    postBuild = ''
      for bin in $out/bin/*; do
        wrapProgram "$bin" \
          --prefix PATH : ${lib.makeBinPath [ pkgs._1password-cli ]} \
          --run '${dotfilesLib.smartConfigLink {
            from = "${claudeConfig}/share/claude";
            to = "$HOME/.claude";
          }}' \
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
