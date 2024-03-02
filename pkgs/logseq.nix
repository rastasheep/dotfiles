{ lib
, stdenvNoCC
, fetchurl
, undmg
}:

stdenvNoCC.mkDerivation rec {
  pname = "logseq";
  version = "0.10.7";
  platform = "darwin-arm64";

  src = fetchurl {
    url = "https://github.com/logseq/logseq/releases/download/${version}/Logseq-${platform}-${version}.dmg";
    sha256 = "b8beab545e0595f0bc8a6c8a6e80f40c2a76e7020bcdc732b3bf144f7d856581";
  };

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;

  nativeBuildInputs = [ undmg ];

  sourceRoot = "Logseq.app";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications/Logseq.app
    cp -R . $out/Applications/Logseq.app

    runHook postInstall
  '';

  meta = with lib; {
    description = "A privacy-first, open-source platform for knowledge management and collaboration";
    homepage = "https://logseq.com";
    license = licenses.unfree;
    platforms = platforms.darwin;
  };
}
