{ pkgs }:

let
  inherit (pkgs) lib;
  dotfilesLib = import ../../lib { inherit pkgs; };

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

    meta = {
      homepage = "https://www.hammerspoon.org";
      description = "Staggeringly powerful macOS desktop automation with Lua";
      license = lib.licenses.mit;
      platforms = lib.platforms.darwin;
    };
  };

  hammerspoonConfig = dotfilesLib.buildConfig {
    name = "hammerspoon";
    src = ./config;
  };

  # Wrapper script to launch the app and setup config
  hammerspoonWrapper = pkgs.writeShellScriptBin "hammerspoon" ''
    ${dotfilesLib.smartConfigLink {
      from = "${hammerspoonConfig}/share/hammerspoon";
      to = "$HOME/.hammerspoon";
    }}

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

  passthru = {
    unwrapped = hammerspoonApp;
    version = hammerspoonApp.version;
  };

  meta = {
    description = "Hammerspoon with custom configuration";
    homepage = "https://www.hammerspoon.org";
    license = lib.licenses.mit;
    platforms = lib.platforms.darwin;
    mainProgram = "hammerspoon";
  };
}
