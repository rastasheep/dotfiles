{ lib
, stdenvNoCC
, fetchurl
, undmg
}:

stdenvNoCC.mkDerivation rec {
  pname = "kicad";
  version = "9.0.7";

  src = fetchurl {
    url = "https://github.com/KiCad/kicad-source-mirror/releases/download/${version}/kicad-unified-universal-${version}.dmg";
    sha256 = "1hl4zm2yli5gkv74vf8537ffqsd2wsjsp9dr6sdcg78imkj2b5a4";
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

  postInstall = ''
    # Remove 3D models library to save ~500-800MB
    rm -rf "$out/Applications/KiCad.app/Contents/SharedSupport/3dmodels"

    # Remove demo projects to save ~50-100MB
    rm -rf "$out/Applications/KiCad.app/Contents/SharedSupport/demos"

    echo "KiCad installed with minimal footprint (3D models and demos removed)"
  '';

  meta = {
    description = "Open Source Electronics Design Automation suite (minimal install without 3D models and demos)";
    homepage = "https://www.kicad.org/";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.darwin;
  };
}
