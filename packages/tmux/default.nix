{ pkgs }:

pkgs.symlinkJoin {
  name = "tmux-configured";
  paths = [ pkgs.tmux ];
  buildInputs = [ pkgs.makeWrapper ];

  postBuild = ''
    wrapProgram $out/bin/tmux \
      --add-flags "-f ${./tmux.conf}"
  '';

  meta = with pkgs.lib; {
    description = "Tmux with custom configuration";
    homepage = "https://github.com/tmux/tmux";
    license = licenses.bsd3;
  };
}
