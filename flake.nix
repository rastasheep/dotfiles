{
  description = "Modular Nix dotfiles for macOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

        # Separate pkgs instance for Claude Code - allows pinning different version if needed
        claudePkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

        # Import custom packages once, reuse everywhere
        git = import ./packages/git { inherit pkgs; };
        scripts = import ./packages/scripts { inherit pkgs; configuredGit = git; };
        tmux = import ./packages/tmux { inherit pkgs; };
        starship = import ./packages/starship { inherit pkgs; };
        zsh = import ./packages/zsh { inherit pkgs; };
        nvim = import ./packages/nvim { inherit pkgs; };
        dircolors = import ./packages/dircolors { inherit pkgs; };

        hammerspoon = import ./packages/hammerspoon { inherit pkgs; };
        ghostty = import ./packages/ghostty { inherit pkgs; };
        claude-code = import ./packages/claude-code { inherit pkgs claudePkgs; };
        macos-defaults = import ./packages/macos-defaults { inherit pkgs; };

        # Custom builds (optional - commented out by default)
        # blender = import ./packages/blender { inherit pkgs; };
        # kicad = import ./packages/kicad { inherit pkgs; };
      in
      {
        # Individual tool packages - can be run with 'nix run .#<tool>'
        packages = {
          # Core CLI tools with custom config
          inherit scripts git tmux starship zsh nvim dircolors;

          # GUI apps and utilities
          inherit hammerspoon ghostty claude-code macos-defaults;

          # Custom builds (uncomment in let block above to enable)
          # inherit blender kicad;

          # Machine-specific bundles
          aleksandars-mbp = import ./machines/aleksandars-mbp { inherit pkgs claudePkgs; };

          # Convenience: all core CLI tools bundle (no machine-specific apps)
          default = pkgs.buildEnv {
            name = "dotfiles-core";
            paths = [ scripts git tmux starship zsh nvim dircolors ];
            pathsToLink = [ "/bin" "/share" "/etc" ];
          };
        };

        # Checks - verify packages build correctly
        checks = {
          # Verify all core packages build
          all-packages = pkgs.buildEnv {
            name = "all-packages-check";
            paths = [
              scripts git tmux starship zsh nvim dircolors
              hammerspoon ghostty claude-code macos-defaults
            ];
            pathsToLink = [ "/bin" "/share" "/etc" "/Applications" ];
          };

          # Verify machine bundle builds
          machine-bundle = import ./machines/aleksandars-mbp { inherit pkgs claudePkgs; };

          # Verify lib utilities are accessible
          lib-check = pkgs.runCommand "lib-check" {} ''
            # Test that lib can be imported and has expected functions
            ${pkgs.nix}/bin/nix-instantiate --eval --expr '
              let lib = import ${./lib} { pkgs = import ${pkgs.path} {}; };
              in lib ? wrapWithConfig && lib ? buildConfig && lib ? smartConfigLink && lib ? mkMeta
            ' > $out
          '';
        };
      }
    );
}
