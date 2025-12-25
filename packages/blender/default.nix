{ lib
, stdenvNoCC
, fetchurl
, undmg
}:

stdenvNoCC.mkDerivation rec {
  pname = "blender";
  version = "4.0.2";
  platform = "macos-arm64";

  src = fetchurl {
    url = "https://mirrors.ocf.berkeley.edu/blender/release/Blender4.0/blender-${version}-${platform}.dmg";
    sha256 = "3debdaeb04fbaa13480c66889bef0c009aa563bb5fca42cdf4484f91195671d2";
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
