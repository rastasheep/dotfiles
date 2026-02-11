{ pkgs, configuredGit ? null }:

# Scripts package with bundled dependencies
# If configuredGit is provided, scripts will use it instead of base git
# This ensures scripts use your custom git config when part of a machine bundle

let
  inherit (pkgs) lib;
in
pkgs.stdenv.mkDerivation {
  name = "scripts";
  src = ./bin;

  nativeBuildInputs = [ pkgs.makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    cp -r $src/* $out/bin/
    chmod +x $out/bin/*

    # Wrap scripts that need external dependencies
    for script in $out/bin/*; do
      wrapProgram "$script" \
        --prefix PATH : ${lib.makeBinPath ([
          (if configuredGit != null then configuredGit else pkgs.git)
          pkgs.fzf
          pkgs.findutils
          pkgs.gnused
          pkgs.coreutils
          pkgs.bash
        ])}
    done
  '';

  passthru = {
    git = if configuredGit != null then configuredGit else pkgs.git;
  };

  meta = {
    description = "Custom shell scripts with bundled dependencies";
    homepage = "https://github.com/rastasheep/dotfiles";
    platforms = lib.platforms.darwin;
  };
}
