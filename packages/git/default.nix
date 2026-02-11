{ pkgs }:

let
  inherit (pkgs) lib;
in
pkgs.symlinkJoin {
  name = "git-configured";
  paths = [ pkgs.git pkgs.git-lfs ];
  buildInputs = [ pkgs.makeWrapper ];

  postBuild = ''
    for bin in $out/bin/git; do
      wrapProgram "$bin" \
        --set GIT_CONFIG_GLOBAL ${./gitconfig} \
        --set GIT_CONFIG_SYSTEM /dev/null \
        --add-flags "-c core.excludesFile=${./gitignore}"
    done
  '';

  passthru = {
    unwrapped = pkgs.git;
    version = pkgs.git.version;
  };

  meta = {
    description = "Git with custom configuration";
    homepage = "https://git-scm.com/";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.darwin;
  };
}
