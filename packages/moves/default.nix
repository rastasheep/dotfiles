{ pkgs }:

let
  inherit (pkgs) lib;
in
pkgs.stdenvNoCC.mkDerivation rec {
  pname = "moves";
  version = "1.9.0";

  src = pkgs.fetchurl {
    name = "${pname}-${version}-source.zip";
    url = "https://github.com/mikker/Moves.app/releases/download/v${version}/Moves.app.zip";
    sha256 = "sha256-gmlOKDq6NzX5DQuhh86x8nk3SZsaLhE1nYVA8SqDeE0=";
  };

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;

  nativeBuildInputs = [ pkgs.unzip ];

  # Set source root since unzip extracts to "Moves.app" directory
  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -r Moves.app $out/Applications/

    runHook postInstall
  '';

  passthru = {
    version = version;
  };

  meta = {
    homepage = "https://getmoves.app";
    description = "Window positioning app for macOS - moves windows with modifier keys";
    license = lib.licenses.mit;
    platforms = lib.platforms.darwin;
  };
}
