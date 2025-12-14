{ pkgs, claudePkgs }:

# Machine-specific bundle for aleksandars-mbp
# Composes custom configured packages with upstream packages

let
  inherit (pkgs) lib;

  # Custom packages from our repository (with custom configs)
  customPackages = {
    # CLI tools with custom config
    git = import ../../packages/git { inherit pkgs; };
    tmux = import ../../packages/tmux { inherit pkgs; };
    starship = import ../../packages/starship { inherit pkgs; };
    zsh = import ../../packages/zsh { inherit pkgs; };
    nvim = import ../../packages/nvim { inherit pkgs; };

    # GUI apps with custom config
    hammerspoon = import ../../packages/hammerspoon { inherit pkgs; };
    ghostty = import ../../packages/ghostty { inherit pkgs; };
    claude-code = import ../../packages/claude-code { inherit pkgs claudePkgs; };

    # Utilities with custom config
    dircolors = import ../../packages/dircolors { inherit pkgs; };
    macos-defaults = import ../../packages/macos-defaults { inherit pkgs; };
  };

  # Scripts package uses the configured git
  scripts = import ../../packages/scripts {
    inherit pkgs;
    configuredGit = customPackages.git;
  };

  # Upstream CLI packages (no custom configuration)
  upstreamCLI = with pkgs; [
    # Core utilities
    coreutils
    ripgrep
    openssl
    tree
    wget

    # Simple tools (no custom config needed)
    direnv
    fzf
    _1password-cli

    # Development tools
    docker
    openvpn
  ];

  # Upstream GUI packages (no custom configuration)
  upstreamGUI = with pkgs; [
    slack
    raycast
  ];

in
pkgs.buildEnv {
  name = "aleksandars-mbp";

  paths = [
    # Custom configured CLI tools
    scripts
    customPackages.git
    customPackages.tmux
    customPackages.starship
    customPackages.zsh
    customPackages.nvim
    customPackages.dircolors

    # Custom configured GUI applications
    customPackages.hammerspoon
    customPackages.ghostty
    customPackages.claude-code

    # System configuration
    customPackages.macos-defaults
  ]
  ++ upstreamCLI
  ++ upstreamGUI;

  pathsToLink = [ "/bin" "/share" "/etc" "/Applications" ];

  meta = {
    description = "Complete dotfiles bundle for aleksandars-mbp";
    platforms = lib.platforms.darwin;
    maintainers = [ ];
  };
}
