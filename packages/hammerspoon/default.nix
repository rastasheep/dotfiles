{ pkgs }:

let
  hammerspoonApp = pkgs.stdenvNoCC.mkDerivation rec {
    pname = "hammerspoon";
    version = "1.0.0";

    src = pkgs.fetchurl {
      name = "${pname}-${version}-source.zip";
      url = "https://github.com/Hammerspoon/hammerspoon/releases/download/${version}/Hammerspoon-${version}.zip";
      sha256 = "sha256-XbcCtV2kfcMG6PWUjZHvhb69MV3fopQoMioK9+1+an4=";
    };

    dontPatch = true;
    dontConfigure = true;
    dontBuild = true;
    dontFixup = true;

    nativeBuildInputs = [ pkgs.unzip ];

    installPhase = ''
      runHook preInstall

      mkdir -p $out/Applications
      cp -r ../Hammerspoon.app $out/Applications/

      runHook postInstall
    '';

    meta = with pkgs.lib; {
      homepage = "https://www.hammerspoon.org";
      description = "Staggeringly powerful macOS desktop automation with Lua";
      license = licenses.mit;
      platforms = platforms.darwin;
    };
  };

  hammerspoonConfig = pkgs.stdenvNoCC.mkDerivation {
    name = "hammerspoon-config";
    src = ./config;

    installPhase = ''
      mkdir -p $out/share/hammerspoon
      cp -r $src/* $out/share/hammerspoon/
    '';
  };

  # Wrapper script to launch the app and setup config
  hammerspoonWrapper = pkgs.writeShellScriptBin "hammerspoon" ''
    # Smart config linking: backup real files, replace symlinks
    if [ -e "$HOME/.hammerspoon" ] && [ ! -L "$HOME/.hammerspoon" ]; then
      # It's a real file/directory, not a symlink - back it up
      backup="$HOME/.hammerspoon.backup.$(date +%Y%m%d-%H%M%S)"
      echo "Backing up existing Hammerspoon config to $backup"
      mv "$HOME/.hammerspoon" "$backup"
    fi

    # Create/update symlink (replaces old symlinks, creates new ones)
    ln -sf ${hammerspoonConfig}/share/hammerspoon "$HOME/.hammerspoon"

    # Open the app
    open ${hammerspoonApp}/Applications/Hammerspoon.app
  '';
in
pkgs.buildEnv {
  name = "hammerspoon-configured";
  paths = [
    hammerspoonApp
    hammerspoonConfig
    hammerspoonWrapper
  ];
  pathsToLink = [ "/Applications" "/share" "/bin" ];

  meta = with pkgs.lib; {
    description = "Hammerspoon with custom configuration";
    homepage = "https://www.hammerspoon.org";
    license = licenses.mit;
    mainProgram = "hammerspoon";
  };
}
