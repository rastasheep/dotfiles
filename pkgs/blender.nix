{ lib
, stdenvNoCC
, fetchurl
, undmg
}:

stdenvNoCC.mkDerivation rec {
  pname = "blender";
  version = "3.6.0";
  platform = "macos-arm64";

  src = fetchurl {
    url = "https://mirrors.ocf.berkeley.edu/blender/release/Blender3.6/blender-${version}-${platform}.dmg";
    sha256 = "ab4e1793343b3d22d7481d30d7f2817b7eb19c9dbdc505db3765336545746e63";
  };

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;

  nativeBuildInputs = [ undmg ];

  sourceRoot = "Blender.app";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications/Blender.app
    cp -R . $out/Applications/Blender.app

    runHook postInstall
  '';

  meta = with lib; {
    description = "3D Creation/Animation/Publishing System";
    homepage = "https://www.blender.org";
    license = licenses.unfree;
    platforms = platforms.darwin;
  };
}
