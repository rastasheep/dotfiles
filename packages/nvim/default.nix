{ pkgs }:

let
  inherit (pkgs) lib;

  flexoki-neovim = pkgs.vimUtils.buildVimPlugin {
    pname = "flexoki-neovim";
    version = "2025-08-26";
    src = pkgs.fetchurl {
      url = "https://github.com/kepano/flexoki-neovim/archive/c3e2251e813d29d885a7cbbe9808a7af234d845d.tar.gz";
      sha256 = "sha256-ere25TqoPfyc2/6yQKZgAQhJXz1wxtI/VZj/0LGMwNw=";
    };
  };

  nvim-treesitter-configured = pkgs.vimPlugins.nvim-treesitter.withPlugins (p: with p; [
    tree-sitter-lua
    tree-sitter-javascript
    tree-sitter-typescript
    tree-sitter-html
    tree-sitter-nix
    tree-sitter-elixir
    tree-sitter-heex
  ]);

  configuredNeovim = pkgs.neovim.override {
    configure = {
      customRC = ''
        lua << EOF
        ${builtins.readFile ./config/init.lua}
        EOF
      '';
      packages.myPlugins = with pkgs.vimPlugins; {
        start = [
          fzf-lua
          gitsigns-nvim
          nvim-treesitter-configured
          flexoki-neovim
        ];
      };
    };

    withRuby = false;
    withPython3 = false;
    withNodeJs = false;
  };
in
configuredNeovim.overrideAttrs (oldAttrs: {
  passthru = (oldAttrs.passthru or {}) // {
    unwrapped = pkgs.neovim;
    version = pkgs.neovim.version;
  };

  meta = (oldAttrs.meta or {}) // {
    description = "Neovim with custom configuration and plugins";
    homepage = "https://neovim.io";
    license = lib.licenses.asl20;
    platforms = lib.platforms.darwin;
    mainProgram = "nvim";
  };
})
