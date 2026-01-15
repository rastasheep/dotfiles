{ pkgs }:

let
  inherit (pkgs) lib;
  dotfilesLib = import ../../lib { inherit pkgs; };

  zshConfig = dotfilesLib.buildConfig {
    name = "zsh";
    src = ./.;
  };

  # Wrapper script that handles zshrc symlinking
  zshWrapper = pkgs.writeShellScriptBin "zsh" ''
    # Set up ~/.zshrc symlink automatically
    ${dotfilesLib.smartConfigLink {
      from = "${zshConfig}/share/zsh/zshrc";
      to = "$HOME/.zshrc";
    }}

    # Execute the real zsh binary
    exec ${pkgs.zsh}/bin/zsh "$@"
  '';
in
pkgs.buildEnv {
  name = "zsh-configured";
  paths = [
    zshWrapper
    pkgs.zsh-autosuggestions
    pkgs.zsh-completions
    zshConfig
  ];
  pathsToLink = [ "/bin" "/share" ];

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
