{
  description = "Fleek Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    claude-nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, home-manager, claude-nixpkgs, ... }@inputs:
    let
      system = "aarch64-darwin";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      claudePkgs = import claude-nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in {
    # Individual tool packages - can be run with 'nix run .#<tool>'
    packages.${system} = {
      # Core CLI tools
      scripts = import ./packages/scripts { inherit pkgs; };
      git = import ./packages/git { inherit pkgs; };
      tmux = import ./packages/tmux { inherit pkgs; };
      starship = import ./packages/starship { inherit pkgs; };
      fzf = import ./packages/fzf { inherit pkgs; };
      direnv = import ./packages/direnv { inherit pkgs; };
      zsh = import ./packages/zsh { inherit pkgs; };
      nvim = import ./packages/nvim { inherit pkgs; };

      # GUI apps and utilities
      hammerspoon = import ./packages/hammerspoon { inherit pkgs; };
      ghostty = import ./packages/ghostty { inherit pkgs; };
      claude-code = import ./packages/claude-code { inherit pkgs claudePkgs; };
      "1password-cli" = import ./packages/1password-cli { inherit pkgs; };
      dircolors = import ./packages/dircolors { inherit pkgs; };
      macos-defaults = import ./packages/macos-defaults { inherit pkgs; };

      # Custom builds (optional - commented out by default)
      # blender = import ./packages/blender { inherit pkgs; };
      # kicad = import ./packages/kicad { inherit pkgs; };

      # Machine-specific bundles
      aleksandars-mbp = import ./machines/aleksandars-mbp { inherit pkgs claudePkgs; };

      # Convenience: all core tools bundle (no machine-specific apps)
      default = pkgs.buildEnv {
        name = "dotfiles-all";
        paths = [
          (import ./packages/scripts { inherit pkgs; })
          (import ./packages/git { inherit pkgs; })
          (import ./packages/tmux { inherit pkgs; })
          (import ./packages/starship { inherit pkgs; })
          (import ./packages/fzf { inherit pkgs; })
          (import ./packages/direnv { inherit pkgs; })
          (import ./packages/zsh { inherit pkgs; })
          (import ./packages/nvim { inherit pkgs; })
        ];
        pathsToLink = [ "/bin" "/share" "/etc" ];
      };
    };

    # Available through 'home-manager --flake .#your-username@your-hostname'

    homeConfigurations = {
      "rastasheep@aleksandars-mbp" = home-manager.lib.homeManagerConfiguration {
        pkgs = pkgs; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = { inherit inputs; }; # Pass flake inputs to our config
        modules = [
          ./home.nix
          ./aleksandars-mbp/rastasheep.nix
        ];
      };
    };
  };
}
