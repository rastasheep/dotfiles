{ pkgs, claudePkgs }:

# Machine-specific bundle for aleksandars-mbp
# Composes custom configured packages with upstream packages

let
  inherit (pkgs) lib;

  # Import custom packages
  git = import ../../packages/git { inherit pkgs; };
  tmux = import ../../packages/tmux { inherit pkgs; };
  starship = import ../../packages/starship { inherit pkgs; };
  zsh = import ../../packages/zsh { inherit pkgs; };
  nvim = import ../../packages/nvim { inherit pkgs; };
  helix = import ../../packages/helix { inherit pkgs; };
  dircolors = import ../../packages/dircolors { inherit pkgs; };
  ghostty = import ../../packages/ghostty { inherit pkgs; };
  claude-code = import ../../packages/claude-code { inherit pkgs claudePkgs; };
  macos-defaults = import ../../packages/macos-defaults { inherit pkgs; };
  tuna = import ../../packages/tuna { inherit pkgs; };
  kicad = import ../../packages/kicad { inherit (pkgs) lib stdenvNoCC fetchurl undmg; };

  # Scripts uses configured git
  scripts = import ../../packages/scripts {
    inherit pkgs;
    configuredGit = git;
  };

in
pkgs.buildEnv {
  name = "aleksandars-mbp";

  paths = [
    # Custom configured packages
    scripts
    git
    tmux
    starship
    zsh
    nvim
    helix
    dircolors
    ghostty
    claude-code
    macos-defaults
    tuna
    kicad

    # Upstream packages (from nixpkgs)
    pkgs.coreutils
    pkgs.ripgrep
    # pkgs.ast-grep  # Temporarily disabled due to build failure in 0.41.0
    pkgs.openssl
    pkgs.tree
    pkgs.wget
    pkgs.direnv
    pkgs.fzf
    pkgs._1password-cli
    pkgs.docker
    pkgs.openvpn
    pkgs.slack
    pkgs.uv
  ];

  pathsToLink = [ "/bin" "/share" "/etc" "/Applications" ];

  meta = {
    description = "Complete dotfiles bundle for aleksandars-mbp";
    platforms = lib.platforms.darwin;
    maintainers = [ ];
  };
}
