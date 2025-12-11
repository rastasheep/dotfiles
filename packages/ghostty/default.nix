{ pkgs }:

let
  ghosttyConfig = pkgs.stdenvNoCC.mkDerivation {
    name = "ghostty-config";
    src = ./config;

    installPhase = ''
      mkdir -p $out/share/ghostty
      cp -r $src/* $out/share/ghostty/
    '';
  };

  # Wrapper to setup config
  ghosttyWrapper = pkgs.symlinkJoin {
    name = "ghostty-with-config";
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

  meta = with pkgs.lib; {
    description = "Ghostty terminal with custom configuration";
    homepage = "https://ghostty.org";
    mainProgram = "ghostty";
  };
}
