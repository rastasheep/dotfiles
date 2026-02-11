{ pkgs }:

let
  inherit (pkgs) lib;

  # Build config directory with proper structure for Helix
  # Helix looks for config in $XDG_CONFIG_HOME/helix/config.toml
  helixConfigDir = pkgs.stdenvNoCC.mkDerivation {
    name = "helix-config";
    src = ./.;
    dontBuild = true;

    installPhase = ''
      mkdir -p $out/helix/themes
      cp $src/config.toml $out/helix/config.toml

      # Copy all theme files if themes directory exists
      if [ -d "$src/themes" ]; then
        cp $src/themes/*.toml $out/helix/themes/ 2>/dev/null || true
      fi
    '';
  };
in
pkgs.symlinkJoin {
  name = "helix-configured";
  paths = [ pkgs.helix ];
  buildInputs = [ pkgs.makeWrapper ];

  postBuild = ''
    wrapProgram $out/bin/hx \
      --set HELIX_RUNTIME "${pkgs.helix}/lib/runtime" \
      --set-default XDG_CONFIG_HOME "${helixConfigDir}"
  '';

  passthru = {
    unwrapped = pkgs.helix;
    version = pkgs.helix.version;
  };

  meta = {
    description = "Helix editor configured with custom Flexoki Alabaster transparent theme";
    homepage = "https://helix-editor.com";
    license = lib.licenses.mpl20;
    platforms = lib.platforms.unix;
    mainProgram = "hx";
  };
}
