{ pkgs }:

pkgs.stdenvNoCC.mkDerivation {
  name = "dircolors-configured";

  buildInputs = [ pkgs.coreutils ];

  unpackPhase = "true";  # No source to unpack

  buildPhase = ''
    # Generate default dircolors database
    ${pkgs.coreutils}/bin/dircolors --print-database > dir_colors
  '';

  installPhase = ''
    mkdir -p $out/share/dircolors
    cp dir_colors $out/share/dircolors/dircolors
  '';

  meta = with pkgs.lib; {
    description = "GNU dircolors configuration for colorized ls output";
    homepage = "https://www.gnu.org/software/coreutils/";
    license = licenses.gpl3Plus;
  };
}
