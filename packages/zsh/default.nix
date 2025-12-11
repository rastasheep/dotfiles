{ pkgs }:

let
  zshConfig = pkgs.stdenv.mkDerivation {
    name = "zsh-config";
    src = ./.;
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

  meta = with pkgs.lib; {
    description = "Zsh with custom configuration and plugins";
    homepage = "https://www.zsh.org/";
    license = licenses.mit;
  };
}
