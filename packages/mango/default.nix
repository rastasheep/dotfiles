{ pkgs, mangoPackage }:

let
  inherit (pkgs) lib;
in
pkgs.symlinkJoin {
  name = "mango-configured";
  paths = [ mangoPackage ];
  buildInputs = [ pkgs.makeWrapper ];

  postBuild = ''
    wrapProgram $out/bin/mango \
      --add-flags "-c ${./mango.conf}"
  '';

  passthru = {
    unwrapped = mangoPackage;
    version = mangoPackage.version or "unknown";
  };

  meta = {
    description = "MangoWC Wayland compositor with custom configuration";
    homepage = "https://github.com/DreamMaoMao/mango";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
}
