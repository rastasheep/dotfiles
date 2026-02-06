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
  hammerspoon = import ../../packages/hammerspoon { inherit pkgs; };
  ghostty = import ../../packages/ghostty { inherit pkgs; };
  claude-code = import ../../packages/claude-code { inherit pkgs claudePkgs; };
  macos-defaults = import ../../packages/macos-defaults { inherit pkgs; };
  leader-key = import ../../packages/leader-key { inherit pkgs; };
  moves = import ../../packages/moves { inherit pkgs; };
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
    hammerspoon
    ghostty
    claude-code
    macos-defaults
    leader-key
    moves
    kicad

    # Upstream packages (from nixpkgs)
    pkgs.coreutils
    pkgs.ripgrep
    pkgs.openssl
    pkgs.tree
    pkgs.wget
    pkgs.direnv
    pkgs.fzf
    pkgs._1password-cli
    pkgs.docker
    pkgs.openvpn
    pkgs.slack
  ];

  pathsToLink = [ "/bin" "/share" "/etc" "/Applications" ];

  meta = {
    description = "Complete dotfiles bundle for aleksandars-mbp";
    platforms = lib.platforms.darwin;
    maintainers = [ ];
  };
}
