{ pkgs }:

let
  inherit (pkgs) lib;
  inherit (import ../../lib { inherit pkgs; }) mkMeta;
in
pkgs.stdenvNoCC.mkDerivation rec {
  pname = "xcode-build-server";
  version = "1.3.0";

  src = pkgs.fetchurl {
    url = "https://github.com/SolaWing/xcode-build-server/archive/refs/tags/v${version}.tar.gz";
    sha256 = "sha256-ksS7hIr1yBKNRgCpP0Xkm4ntlT2IXGAJJFkwOl2A4xI=";
  };

  nativeBuildInputs = [ pkgs.makeWrapper ];

  dontBuild = true;
  dontConfigure = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/libexec/xcode-build-server $out/bin
    cp -r . $out/libexec/xcode-build-server/

    makeWrapper ${pkgs.python3}/bin/python3 $out/bin/xcode-build-server \
      --add-flags "$out/libexec/xcode-build-server/xcode-build-server"

    runHook postInstall
  '';

  meta = mkMeta {
    description = "Bridges xcodebuild/Xcode projects to sourcekit-lsp via the Build Server Protocol";
    homepage = "https://github.com/SolaWing/xcode-build-server";
    license = lib.licenses.mit;
    mainProgram = "xcode-build-server";
  };
}
