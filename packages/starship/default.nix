{ pkgs }:

pkgs.symlinkJoin {
  name = "starship-configured";
  paths = [ pkgs.starship ];
  buildInputs = [ pkgs.makeWrapper ];

  postBuild = ''
    wrapProgram $out/bin/starship \
      --set STARSHIP_CONFIG ${./starship.toml}
  '';

  meta = with pkgs.lib; {
    description = "Starship prompt with custom configuration";
    homepage = "https://starship.rs";
    license = licenses.isc;
  };
}
