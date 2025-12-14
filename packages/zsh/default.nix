{ pkgs }:

let
  inherit (pkgs) lib;

  zshConfig = pkgs.stdenvNoCC.mkDerivation {
    name = "zsh-config";
    src = ./.;
    dontBuild = true;

    installPhase = ''
      mkdir -p $out/etc
      cp ${./zshrc} $out/etc/zshrc

      # Create a .zshenv that sources our config
      cat > $out/etc/zshenv <<'EOF'
# Source the custom zshrc
source ${./zshrc}
EOF
    '';
  };
in
pkgs.buildEnv {
  name = "zsh-configured";
  paths = [
    pkgs.zsh
    pkgs.zsh-autosuggestions
    pkgs.zsh-completions
    zshConfig
  ];
  pathsToLink = [ "/bin" "/share" "/etc" ];

  passthru = {
    unwrapped = pkgs.zsh;
    version = pkgs.zsh.version;
  };

  meta = {
    description = "Zsh with custom configuration and plugins";
    homepage = "https://www.zsh.org/";
    license = lib.licenses.mit;
    platforms = lib.platforms.darwin;
  };
}
