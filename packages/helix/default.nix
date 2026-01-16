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
      mkdir -p $out/helix
      cp ${./config.toml} $out/helix/config.toml
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
    description = "Helix editor configured with Flexoki dark theme and whitespace rendering";
    homepage = "https://helix-editor.com";
    license = lib.licenses.mpl20;
    platforms = lib.platforms.unix;
    mainProgram = "hx";
  };
}
