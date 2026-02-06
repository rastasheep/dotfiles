{ pkgs }:

let
  inherit (pkgs) lib;
  dotfilesLib = import ../../lib { inherit pkgs; };

  leaderKeyApp = pkgs.stdenvNoCC.mkDerivation rec {
    pname = "leader-key";
    version = "1.17.3";

    src = pkgs.fetchurl {
      name = "${pname}-${version}-source.zip";
      url = "https://github.com/mikker/LeaderKey/releases/download/v${version}/Leader.Key.app.zip";
      sha256 = "sha256-B/q+70oHBLdWjzIzibUJ0/9fed9vi1nyer7BF0iGNG8=";
    };

    dontPatch = true;
    dontConfigure = true;
    dontBuild = true;
    dontFixup = true;

    nativeBuildInputs = [ pkgs.unzip ];

    # Set source root since unzip extracts to "Leader Key.app" directory
    sourceRoot = ".";

    installPhase = ''
      runHook preInstall

      mkdir -p $out/Applications
      cp -r "Leader Key.app" $out/Applications/

      runHook postInstall
    '';

    meta = {
      homepage = "https://github.com/mikker/LeaderKey";
      description = "The faster than your launcher launcher for macOS";
      license = lib.licenses.mit;
      platforms = lib.platforms.darwin;
    };
  };

  leaderKeyConfig = dotfilesLib.buildConfig {
    name = "leader-key";
    src = ./config;
  };

  # Wrapper script to launch the app and setup config
  leaderKeyWrapper = pkgs.writeShellScriptBin "leader-key" ''
    ${dotfilesLib.smartConfigLink {
      from = "${leaderKeyConfig}/share/leader-key";
      to = "$HOME/Library/Application Support/Leader Key";
    }}

    # Open the app
    open "${leaderKeyApp}/Applications/Leader Key.app"
  '';
in
pkgs.buildEnv {
  name = "leader-key-configured";
  paths = [
    leaderKeyApp
    leaderKeyConfig
    leaderKeyWrapper
  ];
  pathsToLink = [ "/Applications" "/share" "/bin" ];

  passthru = {
    unwrapped = leaderKeyApp;
    version = leaderKeyApp.version;
  };

  meta = {
    description = "Leader Key with custom configuration";
    homepage = "https://github.com/mikker/LeaderKey";
    license = lib.licenses.mit;
    platforms = lib.platforms.darwin;
    mainProgram = "leader-key";
  };
}
