{ pkgs }:

let
  inherit (pkgs) lib;
in
pkgs.symlinkJoin {
  name = "starship-configured";
  paths = [ pkgs.starship ];
  buildInputs = [ pkgs.makeWrapper ];

  postBuild = ''
    wrapProgram $out/bin/starship \
      --set STARSHIP_CONFIG ${./starship.toml}
  '';

  passthru = {
    unwrapped = pkgs.starship;
    version = pkgs.starship.version;
  };

  meta = {
    description = "Starship prompt with custom configuration";
    homepage = "https://starship.rs";
    license = lib.licenses.isc;
    platforms = lib.platforms.darwin;
  };
}
