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
    # Copy config instead of symlinking to allow UI modifications
    config_dir="$HOME/Library/Application Support/Leader Key"
    config_src="${leaderKeyConfig}/share/leader-key"

    # Only copy if config doesn't exist or if source is newer
    if [ ! -f "$config_dir/config.json" ] || [ "$config_src/config.json" -nt "$config_dir/config.json" ]; then
      mkdir -p "$config_dir"
      cp -f "$config_src/config.json" "$config_dir/config.json"
      chmod 644 "$config_dir/config.json"
      echo "Leader Key config updated from dotfiles" >&2
    fi

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
