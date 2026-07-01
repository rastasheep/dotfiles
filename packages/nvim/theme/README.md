# flexoki theme

Neovim colorscheme using the [Flexoki](https://stephango.com/flexoki) palette with highlighting
philosophy from [Alabaster](https://tonsky.me/blog/syntax-highlighting/) — only data and
definition sites get color, everything else is default text.

## Philosophy

Most themes color too many things. When everything is highlighted, nothing stands out.
This theme colors only:

| Color  | Flexoki | Used for                                      |
|--------|---------|-----------------------------------------------|
| Yellow | `ye`    | Comments (bright — they matter)               |
| Cyan   | `cy`    | Strings, characters                           |
| Purple | `pu`    | Numbers, floats, booleans                     |
| Orange | `or_`   | Named constants                               |
| Blue   | `bl`    | Definition sites only (via LSP semantic tokens) |
| `tx2`  | dim     | Operators, punctuation, delimiters            |
| `tx`   | default | Everything else: keywords, identifiers, calls |

Treesitter cannot distinguish a function definition from a call site, so `@function` gets
default text. LSP semantic tokens (`@lsp.typemod.*.declaration`) provide precise definition
coloring for languages that support it (TypeScript, Lua, etc.).

## Structure

```
theme/
├── colors/
│   ├── flexoki-dark.lua    # :colorscheme flexoki-dark
│   └── flexoki-light.lua   # :colorscheme flexoki-light
├── lua/
│   └── flexoki.lua         # palette, highlight groups, LSP semantic tokens
└── queries/                # vendored nvim-treesitter highlight queries
    ├── ecma/               # shared JS/TS base (inherited by typescript, javascript)
    ├── jsx/                # JSX (inherited by javascript)
    ├── html_tags/          # HTML tags (inherited by html)
    ├── typescript/
    ├── javascript/
    ├── python/
    ├── html/
    ├── nix/
    ├── heex/
    └── swift/
```

## Treesitter queries

Neovim bundles queries only for `lua`, `c`, `markdown`, `vim`, `vimdoc`. All other languages
need queries from an external source. Rather than depending on the `nvim-treesitter` plugin,
queries are vendored directly here from the
[nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) repository.

Parser binaries come from `pkgs.tree-sitter-grammars.*` in Nix. Queries and parsers are
independent — updating one does not require updating the other.

To add a new language:

1. Check for `; inherits:` at the top of the query file — copy inherited languages too
2. Copy `queries/<lang>/highlights.scm` from nvim-treesitter
3. Add `tree-sitter-<lang>` to `treesitterParsers` in `packages/nvim/default.nix`
