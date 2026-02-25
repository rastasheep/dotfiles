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

      # Copy custom tree-sitter queries if they exist
      if [ -d "$src/queries" ]; then
        cp -r $src/queries $out/helix/
      fi
    '';
  };

  # Build custom runtime with our queries overlaid
  customRuntime = pkgs.stdenvNoCC.mkDerivation {
    name = "helix-runtime-custom";
    dontUnpack = true;
    dontBuild = true;

    installPhase = ''
      mkdir -p $out

      # Symlink base runtime directories from helix.passthru.runtime
      ln -s ${pkgs.helix.passthru.runtime}/grammars $out/grammars
      ln -s ${pkgs.helix.passthru.runtime}/themes $out/themes
      ln -s ${pkgs.helix.passthru.runtime}/tutor $out/tutor

      # Copy queries so we can overlay our custom ones
      cp -r ${pkgs.helix.passthru.runtime}/queries $out/queries
      chmod -R +w $out/queries

      # Overlay custom queries if they exist
      if [ -d "${helixConfigDir}/helix/queries" ]; then
        cp -rf "${helixConfigDir}/helix/queries"/* $out/queries/
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
      --set HELIX_RUNTIME "${customRuntime}" \
      --set-default XDG_CONFIG_HOME "${helixConfigDir}"
  '';

  passthru = {
    unwrapped = pkgs.helix;
    version = pkgs.helix.version;
  };

  meta = {
    description = "Helix editor configured with custom Flexoki Alabaster transparent theme and docstring highlighting";
    homepage = "https://helix-editor.com";
    license = lib.licenses.mpl20;
    platforms = lib.platforms.unix;
    mainProgram = "hx";
  };
}
