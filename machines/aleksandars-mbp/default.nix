{ pkgs, claudePkgs }:

# Machine-specific bundle for aleksandars-mbp
# Composes individual tool packages and adds machine-specific packages

let
  # Import core CLI tools
  git = import ../../packages/git { inherit pkgs; };
  scripts = import ../../packages/scripts { inherit pkgs; configuredGit = git; };
  tmux = import ../../packages/tmux { inherit pkgs; };
  starship = import ../../packages/starship { inherit pkgs; };
  fzf = import ../../packages/fzf { inherit pkgs; };
  direnv = import ../../packages/direnv { inherit pkgs; };
  dircolors = import ../../packages/dircolors { inherit pkgs; };
  zsh = import ../../packages/zsh { inherit pkgs; };
  nvim = import ../../packages/nvim { inherit pkgs; };

  # Import GUI apps and machine-specific packages
  hammerspoon = import ../../packages/hammerspoon { inherit pkgs; };
  ghostty = import ../../packages/ghostty { inherit pkgs; };
  claude-code = import ../../packages/claude-code { inherit pkgs claudePkgs; };
  _1password-cli = import ../../packages/1password-cli { inherit pkgs; };
  macos-defaults = import ../../packages/macos-defaults { inherit pkgs; };

  # Additional utility packages
  additionalPackages = [
    pkgs.ripgrep
    pkgs.openssl
    pkgs.tree
    pkgs.docker
    pkgs.slack
    pkgs.wget
    pkgs.raycast
    pkgs.openvpn
  ];
in
pkgs.buildEnv {
  name = "aleksandars-mbp";

  paths = [
    # Core CLI tools
    scripts
    git
    tmux
    starship
    fzf
    direnv
    dircolors
    zsh
    nvim

    # GUI apps
    hammerspoon
    ghostty
    claude-code
    _1password-cli

    # System configuration
    macos-defaults
  ] ++ additionalPackages;

  pathsToLink = [ "/bin" "/share" "/etc" "/Applications" ];

  meta = {
    description = "Complete dotfiles bundle for aleksandars-mbp";
  };
}
