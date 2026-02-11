{ pkgs }:

let
  inherit (pkgs) lib;
in
pkgs.stdenvNoCC.mkDerivation {
  name = "dircolors-configured";

  buildInputs = [ pkgs.coreutils ];

  dontUnpack = true;

  buildPhase = ''
    # Generate default dircolors database
    ${pkgs.coreutils}/bin/dircolors --print-database > dir_colors
  '';

  installPhase = ''
    mkdir -p $out/share/dircolors
    cp dir_colors $out/share/dircolors/dircolors
  '';

  meta = {
    description = "GNU dircolors configuration for colorized ls output";
    homepage = "https://www.gnu.org/software/coreutils/";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.darwin;
  };
}
