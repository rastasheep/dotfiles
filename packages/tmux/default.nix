{ pkgs }:

let
  inherit (pkgs) lib;
in
pkgs.symlinkJoin {
  name = "tmux-configured";
  paths = [ pkgs.tmux ];
  buildInputs = [ pkgs.makeWrapper ];

  postBuild = ''
    wrapProgram $out/bin/tmux \
      --add-flags "-f ${./tmux.conf}"
  '';

  passthru = {
    unwrapped = pkgs.tmux;
    version = pkgs.tmux.version;
  };

  meta = {
    description = "Tmux with custom configuration";
    homepage = "https://github.com/tmux/tmux";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.darwin;
  };
}
