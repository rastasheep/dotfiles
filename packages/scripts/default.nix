{ pkgs, configuredGit ? null }:

# Scripts package with bundled dependencies
# If configuredGit is provided, scripts will use it instead of base git
# This ensures scripts use your custom git config when part of a machine bundle

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
        --prefix PATH : ${pkgs.lib.makeBinPath ([
          (if configuredGit != null then configuredGit else pkgs.git)
          pkgs.fzf
          pkgs.findutils
          pkgs.gnused
          pkgs.coreutils
          pkgs.bash
        ])}
    done
  '';

  meta = with pkgs.lib; {
    description = "Custom shell scripts with bundled dependencies";
  };
}
