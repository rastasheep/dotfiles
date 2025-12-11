{ lib
, stdenvNoCC
, fetchurl
, undmg
}:

stdenvNoCC.mkDerivation rec {
  pname = "kicad";
  version = "7.0.6";
  platform = "macos-arm64";

  src = fetchurl {
    url = "https://github.com/KiCad/kicad-source-mirror/releases/download/7.0.6/kicad-unified-universal-7.0.6-0.dmg";
    sha256 = "sha256-8tz/T8hfEca+qcSnX0BBre7Ept2zFNu58s+aZLHbzdk=";
  };

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;

  nativeBuildInputs = [ undmg ];

  sourceRoot = "KiCad";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -R . $out/Applications

    runHook postInstall
  '';

  meta = with lib; {
    description = "Open Source Electronics Design Automation suite";
    homepage = "https://www.kicad.org/";
    license = lib.licenses.gpl3Plus;
    platforms = platforms.darwin;
  };
}
