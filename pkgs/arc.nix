{ lib
, stdenvNoCC
, fetchurl
, undmg
}:

stdenvNoCC.mkDerivation rec {
  pname = "arc";
  version = "1.32.0-46908";

  src = fetchurl {
    url = "https://releases.arc.net/release/Arc-${version}.dmg";
    sha256 = "sha256-ox8saokFsmzYrM5UcVRaOF1MJGv/J0HUE/svUpAJ18I=";
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
