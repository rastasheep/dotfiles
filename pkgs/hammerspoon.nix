{ lib
, stdenvNoCC
, fetchurl
, unzip
}:

  stdenvNoCC.mkDerivation rec {
    pname = "hammerspoon";
    version = "1.0.0";

    src = fetchurl {
      name = "${pname}-${version}-source.zip";
      url = "https://github.com/Hammerspoon/hammerspoon/releases/download/${version}/Hammerspoon-${version}.zip";
      sha256 = "sha256-XbcCtV2kfcMG6PWUjZHvhb69MV3fopQoMioK9+1+an4=";
    };

    dontPatch = true;
    dontConfigure = true;
    dontBuild = true;
    dontFixup = true;

    nativeBuildInputs = [ unzip ];

    installPhase = ''
      runHook preInstall

      mkdir -p $out/Applications
      cp -r ../Hammerspoon.app $out/Applications/
      runHook postInstall
    '';

    meta = with lib; {
      homepage = "https://www.hammerspoon.org";
      description = "Staggeringly powerful macOS desktop automation with Lua";
      license = licenses.mit;
      platforms = platforms.darwin;
    };
  }
