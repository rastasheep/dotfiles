{ pkgs }:

let
  inherit (pkgs) lib;
  dotfilesLib = import ../../lib { inherit pkgs; };

  ghosttyConfig = dotfilesLib.buildConfig {
    name = "ghostty";
    src = ./config;
  };

  # Wrapper to setup config
  ghosttyWrapper = pkgs.symlinkJoin {
    name = "ghostty-configured";
    paths = [ pkgs.ghostty-bin ];
    buildInputs = [ pkgs.makeWrapper ];

    postBuild = ''
      # Wrap ghostty binary to use our config
      if [ -f $out/bin/ghostty ]; then
        wrapProgram $out/bin/ghostty \
          --add-flags "--config=${ghosttyConfig}/share/ghostty/config"
      fi
    '';
  };
in
pkgs.buildEnv {
  name = "ghostty-configured";
  paths = [
    ghosttyWrapper
    ghosttyConfig
  ];
  pathsToLink = [ "/bin" "/share" "/Applications" ];

  passthru = {
    unwrapped = pkgs.ghostty-bin;
    version = pkgs.ghostty-bin.version or "unknown";
  };

  meta = {
    description = "Ghostty terminal with custom configuration";
    homepage = "https://ghostty.org";
    license = lib.licenses.mit;
    platforms = lib.platforms.darwin;
    mainProgram = "ghostty";
  };
}
