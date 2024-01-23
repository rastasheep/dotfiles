{ lib
, stdenvNoCC
, fetchurl
, undmg
}:

stdenvNoCC.mkDerivation rec {
  pname = "arc";
  version = "1.26.2-45413";

  src = fetchurl {
    url = "https://releases.arc.net/release/Arc-${version}.dmg";
    sha256 = "sha256-0SKFDzGpBjI5AQ15tap+A1ndVx7n5UnsOlRpvmdbSdo=";
  };

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;

  nativeBuildInputs = [ undmg ];

  sourceRoot = "Arc.app";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications/Arc.app
    cp -R . $out/Applications/Arc.app

    runHook postInstall
  '';

  meta = with lib; {
    description = "Web browser reimagined";
    homepage = "https://arc.net/";
    license = licenses.unfree;
    platforms = platforms.darwin;
  };
}
