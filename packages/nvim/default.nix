{ pkgs }:

let
  inherit (pkgs) lib;

  # Flexoki theme plugin
  flexoki-neovim = pkgs.vimUtils.buildVimPlugin {
    pname = "flexoki-neovim";
    version = "2025-08-26";
    src = pkgs.fetchurl {
      url = "https://github.com/kepano/flexoki-neovim/archive/c3e2251e813d29d885a7cbbe9808a7af234d845d.tar.gz";
      sha256 = "sha256-ere25TqoPfyc2/6yQKZgAQhJXz1wxtI/VZj/0LGMwNw=";
    };
  };

  # Treesitter with language parsers
  nvim-treesitter-configured = pkgs.vimPlugins.nvim-treesitter.withPlugins (p: with p; [
    tree-sitter-lua
    tree-sitter-javascript
    tree-sitter-typescript
    tree-sitter-html
    tree-sitter-nix
    tree-sitter-elixir
    tree-sitter-heex
  ]);

  # LSP servers bundled with neovim (not exposed to system)
  # These are kept private and only available to neovim
  bundledLsps = [
    pkgs.elixir-ls                    # Elixir LSP
    pkgs.nodePackages.typescript-language-server  # TypeScript/JavaScript LSP
    pkgs.nodePackages.vscode-langservers-extracted # HTML/CSS/JSON LSPs (no ESLint)
    pkgs.lua-language-server          # Lua LSP
    pkgs.nil                          # Nix LSP
  ];

  # Base neovim configuration
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

  # Combine neovim with bundled LSP servers
  # LSPs are placed in libexec to keep them private
  neovimWithLsps = pkgs.runCommand "neovim-with-lsps-${configuredNeovim.version}"
    {
      buildInputs = [ pkgs.makeWrapper ];
      passthru = {
        unwrapped = pkgs.neovim;
        version = configuredNeovim.version;
        lsps = bundledLsps;  # Expose list of bundled LSPs for inspection
      };
      meta = {
        description = "Neovim with custom configuration, plugins, and bundled LSP servers";
        longDescription = ''
          Neovim configured with Flexoki theme, Treesitter, fzf-lua, and gitsigns.
          Includes bundled LSP servers that are only available to Neovim:
          - elixir-ls (Elixir)
          - typescript-language-server (TypeScript/JavaScript)
          - vscode-langservers-extracted (HTML/CSS/JSON)
          - lua-language-server (Lua)
          - nil (Nix)

          LSP servers are kept private and don't pollute the system PATH.
          Project-specific LSPs in PATH take precedence over bundled ones.
        '';
        homepage = "https://neovim.io";
        license = lib.licenses.asl20;
        platforms = lib.platforms.darwin;
        mainProgram = "nvim";
      };
    }
    ''
      # Copy neovim installation
      mkdir -p $out
      ${pkgs.xorg.lndir}/bin/lndir -silent ${configuredNeovim} $out

      # Create private directory for bundled LSPs (not exposed in bin/)
      mkdir -p $out/libexec/nvim-lsps

      # Symlink bundled LSP binaries to private location
      ${lib.concatMapStringsSep "\n" (lsp: ''
        if [ -d "${lsp}/bin" ]; then
          ${pkgs.xorg.lndir}/bin/lndir -silent "${lsp}/bin" $out/libexec/nvim-lsps
        fi
      '') bundledLsps}

      # Remove the old nvim binary and create wrapper
      rm $out/bin/nvim

      # Wrap nvim to include bundled LSPs in PATH
      # Project LSPs (from parent PATH) are checked first, then bundled ones
      makeWrapper ${configuredNeovim}/bin/nvim $out/bin/nvim \
        --prefix PATH : "$out/libexec/nvim-lsps"
    '';
in
neovimWithLsps
